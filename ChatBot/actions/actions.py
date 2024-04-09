from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
import json


def load_data(filename):
    with open(filename) as file:
        data = json.load(file)["items"]
    return data


def get_opening_hours():
    return load_data("opening_hours.json")


def get_menu():
    return load_data("menu.json")


opening_hours = get_opening_hours()
menu = get_menu()


class ActionRespondOpeningHours(Action):
    def name(self) -> Text:
        return "respond_opening_hours"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        hours = ""
        error = "Unfortunately, We are closed on that day"
        for entity in tracker.latest_message.get("entities", []):
            if entity.get("entity") == "day":
                hours = str(opening_hours[entity["value"]]['open']) + " to " + str(opening_hours[entity["value"]]['close'])
                break

        dispatcher.utter_message(text=f"We work from: " + hours + " on that day" if hours != "" else error)
        return []


class ActionListMenuItems(Action):
    def name(self) -> Text:
        return "respond_menu"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        menu_items = ""
        menu_error = "Unfortunately, I can't access the menu right now."
        for item in menu:
            menu_items += (item["name"] + " " + str(item["price"]) + "USD\n")

        dispatcher.utter_message(text="We can offer you following meals:\n" + menu_items if menu_items != "" else menu_error)

        return []
