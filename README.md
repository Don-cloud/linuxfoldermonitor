# README #

A small, simple yet powerful script which will watch a folder (or folders recursively) and move the incoming file with png extension to Azure blob storage.

### What is this repository for? ###

* This script servers as an example of use case where you need to monitor a folder for incoming files and perform "action" on them. For example, you may need to create thumbnails for any image uploaded by a website user.
* 1.0
* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)

### How do I get set up? ###

* To set this up and running is pretty easy. Once you have the code, install the depency packages and you are good to go!
* Configuration
    * Edit src/process.sh and set the variable to POST file to the azure destination   
   ```
    CONTAINER_URL="<your azure container URL+SAS token>";
   ```
* Dependencies   
    * Install inotify-tools   
    ```
    sudo apt-get install inotify-tools
    ```
    * [Install azcopy azure utility](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#download-azcopy)
   
* Deployment instructions   
    * start monitoring the folder   
    ```   
    sh startmonitoring.sh
    ```   
    Note that you can start monitoring using the inoticoming command as a daemon also.
    Once any file ending wiht ```png``` extension comes to ```incoming``` folder, it will be copied to the azure blob storage and then moved to ```processed``` folder.

### Contribution guidelines ###

* Writing tests
* Code review
* Other guidelines

### Who do I talk to? ###

* Repo owner or admin
* Other community or team contact