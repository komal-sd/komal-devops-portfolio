from datetime import datetime
from app import db

class Project(db.Model):
    __tablename__ = 'projects'

    id          = db.Column(db.Integer, primary_key=True)
    title       = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    tech_stack  = db.Column(db.String(200), nullable=False)
    github_url  = db.Column(db.String(200))
    live_url    = db.Column(db.String(200))
    created_at  = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id':          self.id,
            'title':       self.title,
            'description': self.description,
            'tech_stack':  self.tech_stack,
            'github_url':  self.github_url,
            'live_url':    self.live_url,
            'created_at':  self.created_at.isoformat()
        }


class Skill(db.Model):
    __tablename__ = 'skills'

    id       = db.Column(db.Integer, primary_key=True)
    name     = db.Column(db.String(50), nullable=False)
    category = db.Column(db.String(50), nullable=False)
    level    = db.Column(db.String(20), nullable=False)

    def to_dict(self):
        return {
            'id':       self.id,
            'name':     self.name,
            'category': self.category,
            'level':    self.level
        }


class Milestone(db.Model):
    __tablename__ = 'milestones'

    id          = db.Column(db.Integer, primary_key=True)
    title       = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    type        = db.Column(db.String(50), nullable=False)
    date        = db.Column(db.String(50), nullable=False)
    created_at  = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id':          self.id,
            'title':       self.title,
            'description': self.description,
            'type':        self.type,
            'date':        self.date,
            'created_at':  self.created_at.isoformat()
        }