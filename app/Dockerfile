# ... (all the previous lines are the same) ...
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000

# --- THIS IS THE LINE THAT CHANGES ---
# The command to run when the container starts.
# It tells gunicorn to run the 'app' object from the 'main.py' file.
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "main:app"]