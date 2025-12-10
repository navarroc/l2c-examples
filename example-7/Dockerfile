FROM python:3.10-slim-buster

WORKDIR /app

# TODO - the files here would get injected by the script
COPY example7.py requirements.txt run_tool_pip.sh /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set this for debugging images
#CMD ["tail", "-f", "/dev/null"]

# Set default command to run when the container starts
ENTRYPOINT ["./run_tool_pip.sh"]
