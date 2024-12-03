import logging

from fastapi import FastAPI

from app.monitoring.schemas import Task

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[
        logging.FileHandler("/var/log/fastapi/fastapi.log"),
        logging.StreamHandler(),
    ]
)

logger = logging.getLogger("app")
app = FastAPI()

tasks = []


@app.get("/health")
def health_check():
    return {"status": "ok"}


@app.get("/tasks")
def get_tasks():
    return tasks


@app.post("/tasks")
def add_task(task: Task):
    tasks.append(task)
    return {"message": "Task added", "task": task}


@app.delete("/tasks/{task_id}")
def remove_task(task_id: str):
    if task_id not in tasks:
        return {"message": "Task not found"}
    tasks.remove(task_id)
    return {"message": "Task removed"}
