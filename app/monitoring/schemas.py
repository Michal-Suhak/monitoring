import uuid

from pydantic import BaseModel


class Task(BaseModel):
    id: uuid.UUID
    title: str
    description: str
    done: bool
