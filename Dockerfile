FROM python:3.7.3-alpine

RUN pip install pyyaml \
    && pip install git+https://github.com/Microsoft/SparseSC \
	&& curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

CMD ["python","-c","from SparseSC.src.stt import main; print('OK')"]
