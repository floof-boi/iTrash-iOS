# iTrash-iOS
What's up? Welcome to the iTrash repo, where our code, workspace, and backend goodies live.

**About the Team**

Nice to meet you! We're *KoalaDev* -- a team of first-time CruzHacks attendees working together to clear the confusion around which disposable items can be recycled and which ones cannot. At UCSC, it's go green or go home -- though every day we ask ourselves whether or not our trash is truly trash. More often than not, we can't answer our own question. But fortunately, *iTrash can.*

**About the Project**

iTrash is an iOS app that utilizes the iPhone's live capture feed to recognize and classify items in real-time. It started as an application on Google Cloud Platform, which ran Google's Cloud Vision and AutoML Vision APIs to process images, parse out recognizable objects, and categorize them as recyclable or non-recyclable. We began the project with the hope of deploying our tool as a mobile app, so once the web app was finished, we switched our focus to developing our tool in Swift with XCode. None of our team had previous experience with iOS development, so we took an intellectual leap of faith in order to achieve our original goal. The machine learning aspect added an interesting twist; once we no longer had access to our custom machine learning model on Google Cloud Platform, we wrote a script in Swift to train, evaluate, and re-develop our own image processing model from scratch. iTrash can be built and run on a local iOS device from XCode.

*Acknowledgements*

iTrash would not be what it is now without inspiration and contributions from the following open-source sources:
  - Apple Developer documentation
  - Mark Mansur (https://github.com/markmansur/CoreML-Vision-demo)
