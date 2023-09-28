class TimeEntry:
    def __init__(self, number: str, name: str, seconds: int):
        self.number = number
        self.name = name
        self.seconds = seconds


class TimeEntries:
    def __init__(self):
        self.time_entries = dict[str, TimeEntry]

    def add(self, time_entry: TimeEntry):
        if (self.time_entries[time_entry.number]):
            self.time_entries[time_entry.number].seconds += time_entry.seconds

        self.time_entries[time_entry.number] = time_entry
