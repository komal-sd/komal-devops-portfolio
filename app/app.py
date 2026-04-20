from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from config import Config

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)
    CORS(app)

    with app.app_context():
        from models import Project, Skill, Milestone
        db.create_all()
        seed_data()

    # Health check
    @app.route('/api/health')
    def health():
        return jsonify({'status': 'healthy'})

    # Projects
    @app.route('/api/projects')
    def get_projects():
        projects = Project.query.all()
        return jsonify([p.to_dict() for p in projects])

    # Skills
    @app.route('/api/skills')
    def get_skills():
        skills = Skill.query.all()
        return jsonify([s.to_dict() for s in skills])

    # Milestones
    @app.route('/api/milestones')
    def get_milestones():
        milestones = Milestone.query.all()
        return jsonify([m.to_dict() for m in milestones])

    # Add milestone
    @app.route('/api/milestones', methods=['POST'])
    def add_milestone():
        data = request.get_json()
        milestone = Milestone(
            title       = data['title'],
            description = data['description'],
            type        = data['type'],
            date        = data['date']
        )
        db.session.add(milestone)
        db.session.commit()
        return jsonify(milestone.to_dict()), 201

    return app


def seed_data():
    from models import Project, Skill, Milestone

    if Project.query.count() == 0:
        projects = [
            Project(
                title       = "DevOps Portfolio Dashboard",
                description = "Full stack app deployed on ECS Fargate with Terraform modules and GitHub Actions CI/CD",
                tech_stack  = "Flask, React, PostgreSQL, ECS, Terraform, GitHub Actions",
                github_url  = "https://github.com/komal-sd/komal-devops-portfolio",
                live_url    = ""
            ),
            Project(
                title       = "Task Management API",
                description = "Flask REST API deployed on AWS ECS Fargate with RDS PostgreSQL",
                tech_stack  = "Flask, PostgreSQL, ECS Fargate, Terraform, ECR",
                github_url  = "https://github.com/komal-sd/my-flask-app",
                live_url    = ""
            ),
            Project(
                title       = "Terraform AWS VPC Module",
                description = "Reusable Terraform module for AWS VPC with public, private and database subnets",
                tech_stack  = "Terraform, AWS VPC, NAT Gateway",
                github_url  = "https://github.com/komal-sd/terraform-aws-vpc-module",
                live_url    = ""
            ),
        ]
        db.session.add_all(projects)

    if Skill.query.count() == 0:
        skills = [
            Skill(name="Terraform",       category="IaC",      level="Intermediate"),
            Skill(name="Docker",          category="DevOps",   level="Intermediate"),
            Skill(name="AWS ECS",         category="AWS",      level="Intermediate"),
            Skill(name="AWS RDS",         category="AWS",      level="Intermediate"),
            Skill(name="GitHub Actions",  category="CI/CD",    level="Intermediate"),
            Skill(name="Python/Flask",    category="Backend",  level="Intermediate"),
            Skill(name="Linux",           category="DevOps",   level="Intermediate"),
            Skill(name="PostgreSQL",      category="Database", level="Intermediate"),
        ]
        db.session.add_all(skills)

    if Milestone.query.count() == 0:
        milestones = [
            Milestone(
                title       = "Started DevOps Bootcamp",
                description = "Enrolled in Akhilesh Mishra 20-week AWS DevOps Bootcamp",
                type        = "achievement",
                date        = "Jan 2026"
            ),
            Milestone(
                title       = "Built Terraform VPC Module",
                description = "Published reusable VPC module on GitHub v1.0.0",
                type        = "project",
                date        = "Mar 2026"
            ),
            Milestone(
                title       = "Deployed Flask App on ECS",
                description = "Full CI/CD pipeline with GitHub Actions deploying to ECS Fargate",
                type        = "project",
                date        = "Apr 2026"
            ),
        ]
        db.session.add_all(milestones)

    db.session.commit()


if __name__ == '__main__':
    app = create_app()
    app.run(host='0.0.0.0', port=8000)