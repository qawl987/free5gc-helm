# 使用官方 Ubuntu 20.04 作為基礎映像
FROM ubuntu:20.04

# 設定環境變數，避免 apt-get 在安裝時出現互動式提問
ENV DEBIAN_FRONTEND=noninteractive

# 更新軟體庫並安裝所有必要的系統套件
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3-pip \
    vim \
    net-tools \
    curl && \
    rm -rf /var/lib/apt/lists/*

# 安裝 Python 套件
RUN pip3 install flask requests

# 將您的應用程式腳本複製到容器中
COPY app.py /app/app.py

# 設定容器啟動時要執行的指令
CMD ["python3", "/app/app.py"]