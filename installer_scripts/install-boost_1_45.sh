if [ "`uname -a | grep CYGWIN_NT`" ]; then
  echo "detected cygwin..."
  PLATFORM=pc_cygwin
  CROSSTOOL=/opt/crosstool/gcc-3.3.4-glibc-2.3.2/arm-unknown-linux-gnu/bin/arm-unknown-linux-gnu-g++
else
  DO_LD_CONFIG=true
  PLATFORM=Linux_i686
  CROSSTOOL=/usr/local/opt/crosstool/arm-linux/gcc-3.3.4-glibc-2.3.2/bin/arm-linux-g++
fi

if [ ! $TOOLS_HOME ]; then
  echo "TOOLS_HOME environment variable not defined!"
  exit -1
else
  echo "TOOLS_HOME set to $TOOLS_HOME"
fi

TEMP_DIR=$PWD/temp
echo "Temporary files will be written to $TEMP_DIR"
INSTALL_DIR=$TOOLS_HOME/boostlib/boost_1_45
echo "Boost will be installed to $INSTALL_DIR"

if [ ! -e $TEMP_DIR/boost_1_45_0.tar.bz2 ]; then
  wget -P $TEMP_DIR http://downloads.sourceforge.net/project/boost/boost/1.45.0/boost_1_45_0.tar.bz2
fi

cd $TEMP_DIR

if [ ! -d boost_1_45_0 ]; then
  tar -xvf boost_1_45_0.tar.bz2
fi

cd boost_1_45_0
./bootstrap.sh

rm -rf stage/lib/*
./bjam toolset=gcc cxxflags=-fPIC --with-program_options --with-system --with-date_time --with-thread --with-filesystem --with-test --layout=system stage
mkdir -p $INSTALL_DIR/$PLATFORM/
mv stage/lib/* $INSTALL_DIR/$PLATFORM/

mkdir -p $INSTALL_DIR/include
cp -R boost $INSTALL_DIR/include
