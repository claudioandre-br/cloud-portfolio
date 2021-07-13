#!/bin/bash -ex
################################################################################
##           Version 2 (new Directory Application) user_data script           ##
################################################################################
# Install nodejs
yum -y update
curl -sL https://rpm.nodesource.com/setup_16.x | bash -
yum -y install nodejs

# Install Amazon Linux extras and stress tool
amazon-linux-extras install -y epel
yum -y install stress

# Get and install the application
wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/ILT-TF-100-TECESS-5/app/app.zip
mkdir -p /var/app
unzip app.zip -d /var/app
cd /var/app

# Configure the application
REGION=`curl http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}'`

export PHOTOS_BUCKET=employee-photo-bucket-cl #TODO bucked-id.
export DEFAULT_AWS_REGION=${REGION}
export SHOW_ADMIN_TOOLS=1

# Install dependencies and start the app
npm install
npm start