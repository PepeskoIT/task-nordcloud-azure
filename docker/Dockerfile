# For more information, please refer to https://aka.ms/vscode-docker-python
FROM  ashicorp/terraform:1.3.9

RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
CMD ["python", "sync/src/main.py"]