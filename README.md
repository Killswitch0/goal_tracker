<div align="center">
 <img style="height: 80%; width: 80%;" src="https://github.com/Killswitch0/goal_tracker/assets/89165782/23068ff3-d4e7-4f5c-956f-356db7dea9d8"></img>
</div>



## About :information_source:
The "Goal Tracker" project is a web application designed to help users set and achieve their goals, manage tasks, and build habits. The application provides a platform for individuals to create, track, and accomplish their personal and professional objectives efficiently. It also incorporates a social aspect by allowing users to participate in challenges where they can share their progress with others.

### Features 🎯

- `User Authentication:` Users can create accounts, log in, and securely manage their goals, tasks, and habits.

- `Goal Management:` Users can create goals with names, descriptions, and deadlines. Goals can be categorized for better organization.

- `Task Tracking:` Within each goal, users can create tasks, set deadlines, and mark them as complete when finished. Users can easily keep track of their tasks and monitor their progress.

- `Habit Building:` Users can establish habits by creating habits associated with specific goals. They can track their daily or periodic habit completion.

- `Challenge Participation:` Users can join challenges where they commit to achieving specific goals. Challenges foster a sense of community and healthy competition among participants.

- `Notifications:` The system sends notifications to users for important events, such as task deadlines, challenge updates, or new invitations.

- `User Roles:` Users have different roles, such as regular users and challenge creators, each with their set of permissions and responsibilities.

- `Profile Customization:` Users can personalize their profiles by adding avatars or profile pictures, providing information about themselves, and updating their account settings.

- `Security Features:` The application includes features like email confirmation, password reset, and authentication tokens to ensure the security and privacy of user accounts.

- `Responsive Design:` The web application is designed to be responsive, ensuring a seamless experience on various devices, including desktops, tablets, and smartphones.

## Localization :globe_with_meridians:
Goal Tracker supports: </br> <img src="https://github.com/Killswitch0/goal_tracker/assets/89165782/ece0b897-c9ef-4ebd-95db-9f214bb1a989" style="width: 30px; height: 30px;"></img>
<img src="https://github.com/Killswitch0/goal_tracker/assets/89165782/e6384e51-db51-45ad-b6c7-4d342e547f09" style="width: 30px; height: 30px;"></img>

## Built With 🛠️

 - Programming Languages: `Ruby`.
 - Frameworks: `Ruby on Rails`, `Rspec`.
 - Database: `PostgreSQL`.
 
## Getting Started :rocket:
 
To get a local copy up and running follow these simple steps.

### Prerequisites

- A web browser like Google Chrome.
- A code editor like Visual Studio Code with Git and Ruby.

> You can check if Git is installed by running the following command in the terminal.
```
git --version
```
> Likewise for Ruby installation.
```
ruby --version && irb
```
To install Rails, in the terminal kindly run this command:

```
gem install rails
```

To install Redis server, run this command in the terminal:

```
sudo apt-get update && sudo apt-get install redis
```

### Setup

Clone the repository using the GitHub link provided below.

### Install

In the terminal, go to your file directory and run this command.
```
git clone https://github.com/Killswitch0/goal_tracker.git
```

### Run locally

Make your way to the correct directory by running this command:

```
cd /goal_tracker
```

Install the required dependencies to run the project with this command:
```
bundle install
```

Setup the database, run:
```
rails db:create
rails db:migrate
rails db:seed
```

To precompile assets, run:
```
rails assets:precompile
```

Run Redis server in a separate terminal window:

```
cd /goal_tracker && redis-server
```

Same for run Sidekiq:

```
cd /goal_tracker && bundle exec sidekiq
```

Then run it in your browser with this command:

```
cd /goal_tracker && rails server
```

---
## Quick start ⚡
To get started quickly, use these login details:
### email
```
walt@mail.com
```

### password
```
111111a
```
---

## Run tests

To run tests, please run this command:
```
bundle exec rspec
```
