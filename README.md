# Goal Tracker

The "Goal Tracker" project is a web application designed to help users set and achieve their goals, manage tasks, and build habits. The application provides a platform for individuals to create, track, and accomplish their personal and professional objectives efficiently. It also incorporates a social aspect by allowing users to participate in challenges where they can share their progress with others.

Main features of this website are:

- User Authentication: Users can create accounts, log in, and securely manage their goals, tasks, and habits.

- Goal Management: Users can create goals with names, descriptions, and deadlines. Goals can be categorized for better organization.

- Task Tracking: Within each goal, users can create tasks, set deadlines, and mark them as complete when finished. Users can easily keep track of their tasks and monitor their progress.

- Habit Building: Users can establish habits by creating habits associated with specific goals. They can track their daily or periodic habit completion.

- Challenge Participation: Users can join challenges where they commit to achieving specific goals. Challenges foster a sense of community and healthy competition among participants.

- Notifications: The system sends notifications to users for important events, such as task deadlines, challenge updates, or new invitations.

- User Roles: Users have different roles, such as regular users and challenge creators, each with their set of permissions and responsibilities.

- Profile Customization: Users can personalize their profiles by adding avatars or profile pictures, providing information about themselves, and updating their account settings.

- Security Features: The application includes features like email confirmation, password reset, and authentication tokens to ensure the security and privacy of user accounts.

- Responsive Design: The web application is designed to be responsive, ensuring a seamless experience on various devices, including desktops, tablets, and smartphones.
 
## Built With 🛠️

 - Programming Languages: Ruby, SQL.
 - Framework: Ruby on Rails.
 - Database: PostgreSQL.
 
## Getting Started
 
To get a local copy up and running follow these simple steps.

### Prerequisites

- A web browser like Google Chrome.
- A code editor like Visual Studio Code with Git and Ruby.

> You can check if Git is installed by running the following command in the terminal.
```
$ git --version
```
> Likewise for Ruby installation.
```
$ ruby --version && irb
```
To install rails, in the terminal kindly run this command:

```
$ gem install rails
```

### Setup

Clone the repository using the GitHub link provided below.

### Install

In the terminal, go to your file directory and run this command.
```
$ https://github.com/Killswitch0/goal_tracker.git
```

### Run locally

Make your way to the correct directory by running this command:

```
$ cd /goal_tracker
```

Install the required dependencies to run the project with this command:
```
$ bundle install
```

Setup the database, run:
```
$ rails db:create
$ rails db:migrate
$ rails db:seed
```

Then run it in your browser with this command:

```
$ rails server
```

### Run tests

To run tests, please run this command:
```
$ bundle exec rspec
```
