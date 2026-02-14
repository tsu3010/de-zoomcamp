
# Data Engineering Zoomcamp 2026

Repository for homework and weekly learnings from the [DataTalks.Club Data Engineering Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp).

## 📚 Project Purpose

A hands-on workspace for completing coursework modules that progressively introduce data engineering concepts and tools. This project focuses on practical implementation of modern data engineering workflows using cloud platforms and orchestration tools, working with real-world NYC taxi data.

## 🗂️ Repository Structure

```text
de-zoomcamp/
├── 02-workflow-orchestration/     # Module 2: Workflow orchestration with Kestra
│   ├── flows/                     # Kestra workflow YAML definitions
│   ├── docker-compose.yaml        # Kestra + PostgreSQL services setup
│   └── .env_encoded               # Encrypted environment variables for GCP credentials
│
├── homework-01/                   # Module 1: Docker/Postgres/Terraform/GCP
│   ├── homework_notebook.ipynb    # Solutions to homework questions
│   └── README.md                  # Question answers and SQL queries
│
├── homework-02/                   # Module 2: Workflow Orchestration
│   ├── flows/                     # Kestra flows for data ingestion
│   ├── queries.sql                # BigQuery queries for verification
│   └── README.md                  # Homework answers and explanations
│
├── homework-03/                   # Module 3: Data Warehouse (BigQuery)
│   └── README.md                  # BigQuery optimization and table creation queries
│
├── pipeline/                      # Core data pipeline with local development setup
│   ├── ingest_data.py             # CLI tool for ingesting NYC taxi data to PostgreSQL
│   ├── pipeline.py                # Simple pipeline script generating parquet files
│   ├── docker-compose.yaml        # PostgreSQL + PgAdmin services
│   ├── Dockerfile                 # Containerized pipeline execution
│   └── pyproject.toml             # Project dependencies (uv-based)
│
└── test/                          # Basic testing utilities
```

## 🔧 Technologies & Tools

**Languages:** Python 3.13, SQL, YAML
**Orchestration:** Kestra v1.1
**Databases:** PostgreSQL 18, Google BigQuery
**Cloud:** Google Cloud Platform (GCS, BigQuery)
**Containerization:** Docker, Docker Compose
**Python Stack:** pandas, sqlalchemy, pyarrow, click, tqdm

## Course Modules

### **Module 1**: Docker, Postgres, Terraform, GCP
- Containerized data ingestion pipeline
- PostgreSQL database setup with PgAdmin
- Infrastructure as Code with Terraform
- GCP project and service account configuration
- **Key Files:** [pipeline/ingest_data.py](pipeline/ingest_data.py), [homework-01/](homework-01/)

### **Module 2**: Workflow Orchestration (Kestra)
- Declarative workflow definitions in YAML
- Scheduled data ingestion pipelines
- GCP integration (GCS upload, BigQuery table creation)
- Environment variable management and credential handling
- **Key Files:** [02-workflow-orchestration/flows/](02-workflow-orchestration/flows/), [homework-02/](homework-02/)

### **Module 3**: Data Warehouse (BigQuery)
- External tables pointing to GCS files
- Materialized tables for query optimization
- Partitioning strategies (by datetime)
- Clustering for improved query performance
- Cost optimization techniques
- **Key Files:** [homework-03/](homework-03/)

### **Module 4**: Analytics Engineering (dbt)
- Transforming data in the warehouse
- Building data models and tests
- Documentation and lineage

### **Module 5**: Batch Processing (Spark)
- Distributed data processing
- PySpark fundamentals
- Performance optimization

### **Module 6**: Stream Processing (Kafka)
- Real-time data ingestion
- Event-driven architectures
- Stream processing patterns

### **Module 7**: Final Project
- End-to-end data pipeline implementation

## 🚀 Main Components

### 1. Data Ingestion Pipeline
- Downloads NYC taxi data from GitHub releases
- Loads into PostgreSQL using chunked processing (100K rows/chunk)
- CLI-based with flexible year/month selection
- Progress tracking with tqdm

### 2. Workflow Orchestration
- Kestra workflows from basic hello-world to GCP-integrated pipelines
- Features: templating, scheduling, conditional execution
- Automated GCS uploads and BigQuery table creation

### 3. Data Warehouse
- BigQuery external and materialized tables
- Query optimization with partitioning and clustering
- Cost-effective data storage and retrieval strategies

## 📊 Architecture Flow

```
NYC Taxi Data (GitHub)
    ↓
Local PostgreSQL (development)
    ↓
Kestra Orchestration (workflows)
    ↓
Google Cloud Storage (data lake)
    ↓
BigQuery (data warehouse)
    ↓
Optimized queries (partitioned/clustered)
```

## Progress

- [x] Module 1 - Docker, Postgres, Terraform, GCP
- [x] Module 2 - Workflow Orchestration (Kestra)
- [x] Module 3 - Data Warehouse (BigQuery)
- [ ] Module 4 - Analytics Engineering (dbt)
- [ ] Module 5 - Batch Processing (Spark)
- [ ] Module 6 - Stream Processing (Kafka)
- [ ] Module 7 - Final Project

## 🎯 Learning Outcomes

Through this repository, I've gained hands-on experience with:
- Containerizing data applications with Docker
- Building data ingestion pipelines with Python
- Orchestrating workflows with modern tools (Kestra)
- Managing cloud infrastructure on GCP
- Optimizing data warehouses for cost and performance
- Working with real-world datasets at scale

## 🔗 Resources

- [Course Repository](https://github.com/DataTalksClub/data-engineering-zoomcamp)
- [DataTalks.Club](https://datatalks.club/)
- [Kestra Documentation](https://kestra.io/docs)
- [Google BigQuery Documentation](https://cloud.google.com/bigquery/docs)
