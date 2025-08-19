# Use Python 3.9 slim image as base
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    unzip \
    default-jdk \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV PATH=$PATH:$JAVA_HOME/bin

# Copy local PMD installation
COPY pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0 /app/pmd/pmd-bin-7.15.0

# Set PMD permissions and path
RUN chmod +x /app/pmd/pmd-bin-7.15.0/bin/pmd && \
    chmod +x /app/pmd/pmd-bin-7.15.0/bin/pmd.bat

# Set PMD path
ENV PMD_HOME=/app/pmd/pmd-bin-7.15.0
ENV PATH=$PATH:$PMD_HOME/bin

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY *.py ./
COPY *.xml ./

# Create output directory
RUN mkdir -p /app/output

# Set default command with PMD path
ENTRYPOINT ["python", "main.py"]
CMD ["--help"]
