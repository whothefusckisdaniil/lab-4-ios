import SwiftUI

struct Reminder: Identifiable {
    var id = UUID()
    var text: String
    var date: Date
    var isCompleted: Bool = false
}

struct ContentView: View {
    @State private var reminders = [Reminder]()
    @State private var newReminderText = ""
    @State private var selectedDate = Date()
    @State private var isAddingReminder = false
    
    var body: some View {
        VStack {
            List {
                ForEach(reminders) { reminder in
                    ReminderRow(reminder: reminder)
                }
                .onDelete(perform: deleteReminder)
            }
            .listStyle(PlainListStyle())
            
            if isAddingReminder {
                TextField("Enter your reminder", text: $newReminderText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .padding(.bottom, 10)
                
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding(.bottom, 10)
                
                Button(action: addReminder) {
                    Text("Add")
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            
            Button(action: {
                self.isAddingReminder.toggle()
            }) {
                Image(systemName: isAddingReminder ? "minus.circle.fill" : "plus.circle.fill")
                    .foregroundColor(isAddingReminder ? .red : .blue)
                    .font(.title)
            }
            .padding()
        }
        .padding()
    }
    
    func addReminder() {
        guard !newReminderText.isEmpty else { return }
        
        let newReminder = Reminder(text: newReminderText, date: selectedDate)
        reminders.append(newReminder)
        newReminderText = ""
        isAddingReminder = false
    }
    
    func deleteReminder(at offsets: IndexSet) {
        reminders.remove(atOffsets: offsets)
    }
}

struct ReminderRow: View {
    @State var reminder: Reminder
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(reminder.text)
                    .font(.headline)
                Text("\(reminder.date)")
                    .font(.subheadline)
            }
            
            Spacer()
            
            Button(action: {
                self.reminder.isCompleted.toggle()
            }) {
                if reminder.isCompleted {
                    Image(systemName: "checkmark.square.fill")
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "square")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
