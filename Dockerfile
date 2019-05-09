FROM mcr.microsoft.com/azure-cli

ENV NUMPY_VERSION="1.11.2"

RUN apk --no-cache add openblas-dev

RUN export NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && apk --no-cache add --virtual build-deps \
        musl-dev \
        linux-headers \
        g++ \
    && cd /tmp \
    && ln -s /usr/include/locale.h /usr/include/xlocale.h \
    && pip install cython \
    && cd /tmp \
    && wget https://phoenixnap.dl.sourceforge.net/project/numpy/NumPy/$NUMPY_VERSION/numpy-$NUMPY_VERSION.tar.gz \
    && tar -xzf numpy-$NUMPY_VERSION.tar.gz \
    && rm numpy-$NUMPY_VERSION.tar.gz \
    && cd numpy-$NUMPY_VERSION/ \
    && cp site.cfg.example site.cfg \
    && echo -en "\n[openblas]\nlibraries = openblas\nlibrary_dirs = /usr/lib\ninclude_dirs = /usr/include\n" >> site.cfg \
    && python -q setup.py build -j ${NPROC} --fcompiler=gfortran install \
    && cd /tmp \
    && rm -r numpy-$NUMPY_VERSION \
    && pip install scipy \
    && pip install --upgrade pip \
    && apk --no-cache del --purge build-deps \
	&& apk add git \ 
	&& pip install git+https://github.com/Microsoft/SparseSC

CMD ["python","-c","from SparseSC.src.stt import main; print('OK');"]
