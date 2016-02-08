FROM ubuntu:15.10

MAINTAINER Thomas Frössman <thomasf@jossystem.se>

# Make sure apt-get is up to date and dependent packages are installed
RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
          autogen \
          automake \
          build-essential \
          ca-certificates \
          clang \
          cpio \
          curl \
          gcc-mingw-w64 \
          gcc-multilib \
          git \
          libgtk-3-dev \
          libnotify-dev \
          libssl-dev \
          libtool \
          libxml2-dev \
          libappindicator3-dev \
          llvm-dev \
          make \
          mercurial \
          patch \
          pkg-config \
          unzip \
          uuid-dev \
          wget \
          xz-utils \
          apt-transport-https \
          lsb-release \
          ssh \
          icnsutils \
        ;

# install nodejs
run curl -sL https://deb.nodesource.com/setup_4.x | bash - && apt-get install -y nodejs

# install go
run mkdir -p /tmp/go-bootstrap && curl -sSL https://storage.googleapis.com/golang/go1.5.3.linux-amd64.tar.gz | tar -C /tmp/go-bootstrap -xz
run curl -sSL https://storage.googleapis.com/golang/go1.5.3.src.tar.gz | tar -C /usr/local -xz
run cd /usr/local/go/src && GOROOT_BOOTSTRAP=/tmp/go-bootstrap/go ./make.bash --no-clean 2>&1
run rm -rf /tmp/go-bootstrap && mkdir -p /go/bin
env GOPATH /go
env PATH $GOPATH/bin:/usr/local/go/bin:$PATH
run for GOOS in linux darwin windows; do for GOARCH in amd64 386; do export GOOS; export GOARCH; echo "building $GOOS-$GOARCH"; go install std; done; done
env GO15VENDOREXPERIMENT 1

# install Go related tools
run go get \
    github.com/jteeuwen/go-bindata/go-bindata/ \
    golang.org/x/tools/cmd/vet \
    golang.org/x/tools/cmd/cover

# install nodejs tools
run npm install -g webpack
run npm install -g \
        eslint \
        babel-eslint \
        eslint-plugin-react \
        coffeelint \
        jsxhint
