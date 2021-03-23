Feature: Camera Skill

  Background:
    Given an english speaking user

  Scenario Outline: Take a picture
    When the user says "<take a picture>"
    Then "camera" should reply with dialog from "acknowledge.dialog"

   Examples: Take a picture
     | take a picture |
     | take a selfie |
     | take my picture |
     | snap picture |