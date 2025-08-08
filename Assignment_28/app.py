from flask import Flask, request, render_template
import numpy as np
import pandas as pd

from src.pipeline.prediction_pipeline import CustomData, PredictPipeline 

app = Flask(__name__)

# Route: Welcome Page
@app.route('/')
def index():
    return render_template('index.html')

# Route: Input Form and Prediction
@app.route('/predictdata', methods=['GET', 'POST'])
def predict_datapoint():
    if request.method == 'GET':
        return render_template('home.html')

    try:
        # Collect input from form
        data = CustomData(
            price=float(request.form.get('price')),
            volume=float(request.form.get('volume')),
            market_cap=float(request.form.get('market_cap'))
        )

        # Convert to DataFrame
        pred_df = data.get_data_as_data_frame()

        # Predict using the pipeline
        predict_pipeline = PredictPipeline()
        result = predict_pipeline.predict(pred_df)

        # Return result to user
        return render_template('home.html', results=round(result[0], 4))

    except Exception as e:
        return f"An error occurred: {e}", 500

if __name__ == "__main__":
    print("✅ Server started at http://127.0.0.1:5000")
    app.run(host="0.0.0.0", port=5000, debug=False, use_reloader=False)
