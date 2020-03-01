FROM tzutalin/py2qt4
RUN git clone https://github.com/tzutalin/labelImg /labelImg
WORKDIR /labelImg
RUN make qt4py2
CMD [ "python", "/labelImg/labelImg.py" ]