FROM python:3.7.3-alpine

RUN sudo apt-get install git \
	&& pip install pyyaml \
    && pip install git+https://github.com/Microsoft/SparseSC \
	&& curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

CMD ["python","-c","from SparseSC.src.stt import main; print('OK')"]
