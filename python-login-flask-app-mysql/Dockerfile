FROM python:3.8-slim

WORKDIR /app

# Copy the current directory contents into the container
COPY . /app


RUN pip install -r requirements.txt

EXPOSE 5000

#ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]
