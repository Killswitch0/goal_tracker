// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import CalendarController from "./calendar_controller"
application.register("calendar", CalendarController)

import ChallengesController from "./challenges_controller"
application.register("challenges", ChallengesController)

import ChartsController from "./charts_controller"
application.register("charts", ChartsController)

import GoalsController from "./goals_controller"
application.register("goals", GoalsController)

import NavbarController from "./navbar_controller"
application.register("navbar", NavbarController)
