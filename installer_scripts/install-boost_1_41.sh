if [ "`uname -a | grep CYGWIN_NT`" ]; then
  echo "detected cygwin..."
  PLATFORM=pc_cygwin
else
  PLATFORM=Linux_i686
fi

if [ ! $TOOLS_HOME ]; then
  echo "TOOLS_HOME environment variable not defined!"
  exit -1
else
  echo "TOOLS_HOME set to $TOOLS_HOME"
fi

TEMP_DIR=`pwd`/temp
echo "Temporary files will be written to $TEMP_DIR"
INSTALL_DIR=$TOOLS_HOME/boostlib/boost_1_41
echo "Boost will be installed to $INSTALL_DIR"

if [ ! -e $TEMP_DIR/boost_1_41_0.tar.bz2 ]; then
  wget -P $TEMP_DIR http://sourceforge.net/projects/boost/files/boost/1.41.0/boost_1_41_0.tar.bz2
fi

cd $TEMP_DIR

if [ ! -d boost_1_41_0 ]; then
  tar -xvf boost_1_41_0.tar.bz2
fi

#cat ../patches/exception_ptr_base.patch | patch -d boost_1_41_0 -p 0 -N
cd boost_1_41_0
./bootstrap.sh

rm -rf stage/lib/*
./bjam toolset=gcc --with-program_options --with-system --with-date_time --with-thread --with-filesystem --layout=system stage
mkdir -p $INSTALL_DIR/$PLATFORM/
mv stage/lib/* $INSTALL_DIR/$PLATFORM/

mkdir -p $INSTALL_DIR/include
cp -R boost $INSTALL_DIR/include
