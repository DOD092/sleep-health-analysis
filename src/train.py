import os
import json
import shutil
import joblib
import pandas as pd

from sklearn.model_selection import train_test_split
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler, LabelEncoder
from sklearn.impute import SimpleImputer
from sklearn.metrics import (
    accuracy_score,
    precision_score,
    recall_score,
    f1_score,
    classification_report
)

from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from xgboost import XGBClassifier


BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_PATH = os.path.join(BASE_DIR, "dataset", "preprocess", "sleep_health_clean.csv")
MODEL_DIR = os.path.join(BASE_DIR, "models")
OUTPUT_DIR = os.path.join(BASE_DIR, "dataset", "output")

os.makedirs(MODEL_DIR, exist_ok=True)
os.makedirs(OUTPUT_DIR, exist_ok=True)

TARGET = "Sleep_Disorder"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)
    df.columns = [col.strip() for col in df.columns]
    return df


def prepare_data(df: pd.DataFrame):
    drop_cols = ["Blood_Pressure"]
    df = df.drop(columns=drop_cols, errors="ignore")

    if TARGET not in df.columns:
        raise ValueError(f"Không tìm thấy cột target: {TARGET}")

    X = df.drop(columns=[TARGET])
    y = df[TARGET]

    label_encoder = LabelEncoder()
    y_encoded = label_encoder.fit_transform(y)

    return X, y_encoded, label_encoder


def build_preprocessor(X: pd.DataFrame) -> ColumnTransformer:
    num_features = X.select_dtypes(include=["int64", "float64"]).columns.tolist()
    cat_features = X.select_dtypes(include=["object"]).columns.tolist()

    num_transformer = Pipeline(steps=[
        ("imputer", SimpleImputer(strategy="median")),
        ("scaler", StandardScaler())
    ])

    cat_transformer = Pipeline(steps=[
        ("imputer", SimpleImputer(strategy="most_frequent")),
        ("onehot", OneHotEncoder(handle_unknown="ignore"))
    ])

    preprocessor = ColumnTransformer(transformers=[
        ("num", num_transformer, num_features),
        ("cat", cat_transformer, cat_features)
    ])

    return preprocessor


def get_models():
    return {
        "SVM-based": SVC(
            C=1.0,
            kernel="rbf",
            gamma="scale",
            probability=True,
            random_state=42
        ),
        "KNN-based": KNeighborsClassifier(
            n_neighbors=5,
            weights="distance"
        ),
        "DT-based": DecisionTreeClassifier(
            max_depth=6,
            min_samples_split=5,
            random_state=42
        ),
        "RF-based": RandomForestClassifier(
            n_estimators=200,
            max_depth=8,
            min_samples_split=5,
            random_state=42
        ),
        "XGBoost": XGBClassifier(
            n_estimators=200,
            max_depth=8,
            learning_rate=0.05,
            subsample=0.8,
            colsample_bytree=0.8,
            objective="multi:softprob",
            eval_metric="mlogloss",
            random_state=42
        )
    }


def evaluate_model(model_name: str, pipeline: Pipeline, X_test, y_test, label_encoder: LabelEncoder):
    y_pred = pipeline.predict(X_test)

    metrics = {
        "Model": model_name,
        "Accuracy": accuracy_score(y_test, y_pred),
        "Precision_Macro": precision_score(y_test, y_pred, average="macro", zero_division=0),
        "Recall_Macro": recall_score(y_test, y_pred, average="macro", zero_division=0),
        "F1_Macro": f1_score(y_test, y_pred, average="macro", zero_division=0),
        "Classification_Report": classification_report(
            y_test,
            y_pred,
            target_names=label_encoder.classes_,
            output_dict=True,
            zero_division=0
        )
    }
    return metrics


def save_best_model(results_df: pd.DataFrame):
    best_model_name = results_df.iloc[0]["Model"]
    best_model_filename = best_model_name.lower().replace("-", "_").replace(" ", "_") + ".pkl"

    src_path = os.path.join(MODEL_DIR, best_model_filename)
    dst_path = os.path.join(MODEL_DIR, "best_model.pkl")

    shutil.copy(src_path, dst_path)
    return best_model_name, dst_path


def main():
    print("===== Loading data =====")
    df = load_data(DATA_PATH)

    X, y_encoded, label_encoder = prepare_data(df)
    preprocessor = build_preprocessor(X)

    X_train, X_test, y_train, y_test = train_test_split(
        X,
        y_encoded,
        test_size=0.2,
        random_state=42,
        stratify=y_encoded
    )

    models = get_models()

    all_results = []
    detailed_reports = {}

    for model_name, model in models.items():
        print(f"\n===== Training {model_name} =====")

        pipeline = Pipeline(steps=[
            ("preprocessor", preprocessor),
            ("classifier", model)
        ])

        pipeline.fit(X_train, y_train)

        metrics = evaluate_model(model_name, pipeline, X_test, y_test, label_encoder)

        print(f"Accuracy        : {metrics['Accuracy']:.4f}")
        print(f"Precision Macro : {metrics['Precision_Macro']:.4f}")
        print(f"Recall Macro    : {metrics['Recall_Macro']:.4f}")
        print(f"F1 Macro        : {metrics['F1_Macro']:.4f}")

        all_results.append({
            "Model": metrics["Model"],
            "Accuracy": metrics["Accuracy"],
            "Precision_Macro": metrics["Precision_Macro"],
            "Recall_Macro": metrics["Recall_Macro"],
            "F1_Macro": metrics["F1_Macro"]
        })

        detailed_reports[model_name] = metrics["Classification_Report"]

        model_filename = model_name.lower().replace("-", "_").replace(" ", "_") + ".pkl"
        model_path = os.path.join(MODEL_DIR, model_filename)
        joblib.dump(pipeline, model_path)

    joblib.dump(label_encoder, os.path.join(MODEL_DIR, "label_encoder.pkl"))

    results_df = pd.DataFrame(all_results).sort_values(by="F1_Macro", ascending=False)
    results_df.to_csv(os.path.join(OUTPUT_DIR, "model_comparison.csv"), index=False)

    with open(os.path.join(OUTPUT_DIR, "classification_reports.json"), "w", encoding="utf-8") as f:
        json.dump(detailed_reports, f, indent=4)

    best_model_name, best_model_path = save_best_model(results_df)

    print("\n===== Final Comparison =====")
    print(results_df)

    print("\n===== Best Model =====")
    print(f"Best model: {best_model_name}")
    print(f"Saved as : {best_model_path}")

    print("\nĐã lưu:")
    print("- Từng model vào thư mục models/")
    print("- label_encoder.pkl")
    print("- best_model.pkl")
    print("- model_comparison.csv")
    print("- classification_reports.json")


if __name__ == "__main__":
    main()