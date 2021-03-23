# Copyright 2021 Mycroft AI Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
from mycroft import MycroftSkill, intent_handler


class CameraSkill(MycroftSkill):
    """
    Camera Skill Class
    """

    def __init__(self):
        super(CameraSkill, self).__init__("CameraSkill")
        self.camera_mode = None
        self.save_folder = os.path.expanduser("~/Pictures")
        if not os.path.isdir(self.save_folder):
            os.makedirs(self.save_folder)

    def initialize(self):
        # Register Camera GUI Events
        self.gui.register_handler(
            "CameraSkill.ViewPortStatus", self.handle_camera_status
        )
        self.gui.register_handler(
            "CameraSkill.EndProcess", self.handle_camera_completed
        )

    @intent_handler("CaptureSingleShot.intent")
    def handle_capture_single_shot(self, _):
        self.speak_dialog("acknowledge")
        self.gui["singleshot_mode"] = False
        self.handle_camera_activity("singleshot")

    @intent_handler("OpenCamera.intent")
    def handle_open_camera(self, _):
        self.speak_dialog("acknowledge")
        self.gui["singleshot_mode"] = False
        self.handle_camera_activity("generic")

    def handle_camera_completed(self, _=None):
        self.gui.remove_page("Camera.qml")
        self.gui.release()

    def handle_camera_status(self, message):
        current_status = message.data.get("status")
        if current_status == "generic":
            self.gui["singleshot_mode"] = False
        if current_status == "imagetaken":
            self.gui["singleshot_mode"] = False
        if current_status == "singleshot":
            self.gui["singleshot_mode"] = True

    def handle_camera_activity(self, activity):
        self.gui["save_path"] = self.save_folder
        if activity == "singleshot":
            self.gui["singleshot_mode"] = True
        if activity == "generic":
            self.gui["singleshot_mode"] = False
        self.gui.show_page("Camera.qml", override_idle=60)

    def stop(self):
        self.handle_camera_completed()


def create_skill():
    return CameraSkill()
