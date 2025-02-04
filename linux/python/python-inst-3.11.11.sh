sudo apt update && sudo apt install -y build-essential \
    zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev \
    libssl-dev libreadline-dev libffi-dev curl

cd /usr/src
sudo curl -O https://www.python.org/ftp/python/3.11.11/Python-3.11.11.tgz
sudo tar -xf Python-3.11.11.tgz
cd Python-3.11.11

sudo ./configure --enable-optimizations
sudo make -j$(nproc)
sudo make altinstall  # Avoids replacing `python` system binary

sudo ln -sf /usr/local/bin/python3.11 /usr/bin/python3
