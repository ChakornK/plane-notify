FROM python:3.9

WORKDIR /plane-notify

# Added needed folder for plane-notify process
RUN mkdir /home/plane-notify

# Set the Chrome repo.
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

RUN apt-get update && apt-get -y install --no-install-recommends \
    google-chrome-stable \
    python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Chrome 114.0.5735.90.
RUN wget --no-verbose https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_114.0.5735.90-1_amd64.deb \
    && apt-get -y --allow-downgrades install ./google-chrome-stable_114.0.5735.90-1_amd64.deb
    
# Add pipenv
RUN pip install pipenv

# Install dependencies
COPY Pipfile* ./
RUN pipenv install

COPY . .
CMD pipenv run python /plane-notify/__main__.py
