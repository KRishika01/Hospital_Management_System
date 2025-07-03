import pymysql

def connect_to_db():
    try:
        return pymysql.connect(
            host="localhost",
            port=3306,  # Update if a different port is used
            user="root",  # Replace with your MySQL username
            password="140406tm",  # Replace with your MySQL password
            database="Dna_project",  # Replace with your database name
            cursorclass=pymysql.cursors.DictCursor  # To return results as dictionaries
        )
    except pymysql.MySQLError as e:
        print(f"Error connecting to the database: {e}")
        return None

# Error-safe query execution
def execute_query(query, params=None, fetchall=True):
    conn = connect_to_db()
    if not conn:
        return None
    try:
        cursor = conn.cursor()
        cursor.execute(query, params)
        if fetchall:
            result = cursor.fetchall()
        else:
            result = cursor.fetchone()
        conn.commit()
        return result
    except pymysql.MySQLError as e:
        print(f"Database query error: {e}")
    finally:
        cursor.close()
        conn.close()
    return None

# Queries with error handling
def get_doctors_by_department(department_id):
    # Check if the department exists
    department_check_query = "SELECT DeptID FROM DEPARTMENT WHERE DeptID = %s;"
    department_exists = execute_query(department_check_query, (department_id,), fetchall=False)
    
    if not department_exists:
        print(f"Error: Department with ID {department_id} does not exist.")
        return

    # Fetch doctors if the department exists
    query = """
    SELECT Doc_FName, Doc_Mname, Doc_Lname, DeptID
    FROM DOCTOR
    WHERE DeptID = %s;
    """
    result = execute_query(query, (department_id,))
    if result:
        print("Doctors in Department:", result)
    else:
        print(f"No doctors found in Department ID {department_id}.")


def get_patients_by_doctor(doctor_id):
    # Check if the doctor exists
    doctor_check_query = "SELECT DoctorID FROM DOCTOR WHERE DoctorID = %s;"
    doctor_exists = execute_query(doctor_check_query, (doctor_id,), fetchall=False)
    
    if not doctor_exists:
        print(f"Error: Doctor with ID {doctor_id} does not exist.")
        return

    # Fetch patients treated by the doctor
    query = """
    SELECT P.PFname, P.PMname, P.PLname, P.PatientID
    FROM PATIENT P
    JOIN APPOINTMENT A ON P.PatientID = A.Patient_Id
    WHERE A.Doctor_Id = %s;
    """
    result = execute_query(query, (doctor_id,))
    if result:
        print("Patients treated by Doctor:", result)
    else:
        print(f"No patients found for Doctor ID {doctor_id}.")


def count_doctors_by_department():
    query = """
    SELECT DeptID, COUNT(*) AS Number_of_Doctors
    FROM DOCTOR
    GROUP BY DeptID;
    """
    result = execute_query(query)
    if result:
        print("Doctor Count by Department:", result)
    else:
        print("No data found or an error occurred.")

def get_appointments_by_date(date):
    query = """
    SELECT Appointment_Id, Doctor_Id, Patient_Id, Appointment_Time
    FROM APPOINTMENT
    WHERE Date = %s;
    """
    result = execute_query(query, (date,))
    if result:
        print(f"Appointments on {date}:", result)
    else:
        print("No appointments found or an error occurred.")

def get_available_medicines():
    query = """
    SELECT Medicine_Name, Quantity_Available, Price_per_unit
    FROM PHARMACY
    WHERE Expiry_Date > CURDATE();
    """
    result = execute_query(query)
    if result:
        print("Available Medicines:", result)
    else:
        print("No medicines found or an error occurred.")

def update_patient_contact(patient_id, new_contact_no):
    # Check if the patient exists
    patient_check_query = "SELECT PatientID FROM PATIENT WHERE PatientID = %s;"
    patient_exists = execute_query(patient_check_query, (patient_id,), fetchall=False)
    
    if not patient_exists:
        print(f"Error: Patient with ID {patient_id} does not exist.")
        return

    # Update patient contact number
    query = """
    UPDATE PATIENT
    SET Contact_No = %s
    WHERE PatientID = %s;
    """
    try:
        execute_query(query, (new_contact_no, patient_id), fetchall=False)
        print(f"Patient contact updated successfully for Patient ID {patient_id}.")
    except Exception as e:
        print(f"Failed to update patient contact due to an error: {e}")


def update_app_time(patient_id, new_app_time):
    # Check if the patient exists in the PATIENT table
    patient_check_query = "SELECT PatientID FROM PATIENT WHERE PatientID = %s;"
    patient_exists = execute_query(patient_check_query, (patient_id,), fetchall=False)

    if not patient_exists:
        print(f"Error: Patient with ID {patient_id} does not exist.")
        return

    # Check if the patient has an appointment
    appointment_check_query = "SELECT Patient_Id FROM APPOINTMENT WHERE Patient_Id = %s;"
    appointment_exists = execute_query(appointment_check_query, (patient_id,), fetchall=False)

    if not appointment_exists:
        print(f"Error: No appointment found for Patient ID {patient_id}.")
        return

    # Update appointment time
    query = """
    UPDATE APPOINTMENT
    SET Appointment_time = %s
    WHERE Patient_Id = %s;
    """
    try:
        execute_query(query, (new_app_time, patient_id), fetchall=False)
        print(f"Appointment time updated successfully for Patient ID {patient_id}.")
    except Exception as e:
        print(f"Failed to update appointment time due to an error: {e}")


def restock_medicine(medicine_id, restock_amount):
    # Check if the medicine exists in the PHARMACY table
    medicine_check_query = "SELECT Medicine_Id FROM PHARMACY WHERE Medicine_Id = %s;"
    medicine_exists = execute_query(medicine_check_query, (medicine_id,), fetchall=False)

    if not medicine_exists:
        print(f"Error: Medicine with ID {medicine_id} does not exist.")
        return

    # Update the medicine stock
    query = """
    UPDATE PHARMACY
    SET Quantity_Available = Quantity_Available + %s
    WHERE Medicine_Id = %s;
    """
    try:
        execute_query(query, (restock_amount, medicine_id), fetchall=False)
        print(f"Medicine with ID {medicine_id} restocked successfully by {restock_amount} units.")
    except Exception as e:
        print(f"Failed to restock medicine due to an error: {e}")


def search_patient_by_name(name_substring):
    query = """
    SELECT PatientID, PFname, PMname, PLname, Contact_No
    FROM PATIENT
    WHERE CONCAT(PFname, ' ', PMname, ' ', PLname) LIKE %s;
    """
    result = execute_query(query, (f"%{name_substring}%",))
    if result:
        print("Patients matching the search:", result)
    else:
        print(f"No patients found containing '{name_substring}' in their name.")


def surgeries_report():
    query = """
    SELECT D.DoctorID, CONCAT(D.Doc_FName, ' ', D.Doc_Mname, ' ', D.Doc_Lname) AS Doctor_Name, 
           COUNT(S.Surgery_Id) AS Number_of_Surgeries
    FROM DOCTOR D
    LEFT JOIN SURGERY S ON D.DoctorID = S.Doctor_Id
    GROUP BY D.DoctorID;
    """
    result = execute_query(query)
    if result:
        print("Surgeries Report:", result)
    else:
        print("No surgeries data found.")


def patient_report():
    query = """
    SELECT D.DoctorID, CONCAT(D.Doc_FName, ' ', D.Doc_Mname, ' ', D.Doc_Lname) AS Doctor_Name,
           COUNT(A.Patient_Id) AS Number_of_Patients
    FROM DOCTOR D
    LEFT JOIN APPOINTMENT A ON D.DoctorID = A.Doctor_Id
    GROUP BY D.DoctorID;
    """
    result = execute_query(query)
    if result:
        print("Patient Report:", result)
    else:
        print("No patient data found.")


def insert_new_doctor(doctor_data):
    query = """
    INSERT INTO DOCTOR (DoctorID,Doc_Fname, Doc_Mname, Doc_Lname, Contact_No,Gender, DOB, DeptID, Supervisor_ID)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);
    """
    try:
        execute_query(query, doctor_data, fetchall=False)
        print("New Doctor record inserted successfully.")
    except Exception as e:
        print(f"Failed to insert new Doctor record: {e}")


def delete_appointment():
    try:
        # Input patient ID, appointment date, and time
        patient_id = int(input("Enter Patient ID: "))
        appointment_date = input("Enter Appointment Date (YYYY-MM-DD): ")
        appointment_time = input("Enter Appointment Time (HH:MM:SS): ")
    except ValueError:
        print("Invalid input. Patient ID must be an integer, and date/time must be in proper format.")
        return

    # Check if the patient exists
    patient_check_query = "SELECT PatientID FROM PATIENT WHERE PatientID = %s;"
    patient_exists = execute_query(patient_check_query, (patient_id,), fetchall=False)

    if not patient_exists:
        print(f"Error: Patient with ID {patient_id} does not exist.")
        return

    # Check if the appointment exists
    appointment_check_query = """
    SELECT * FROM APPOINTMENT
    WHERE Patient_Id = %s AND Date = %s AND Appointment_time = %s;
    """
    appointment_exists = execute_query(appointment_check_query, (patient_id, appointment_date, appointment_time), fetchall=False)

    if not appointment_exists:
        print(f"No appointment found for Patient ID {patient_id} on {appointment_date} at {appointment_time}.")
        return

    # Delete the appointment
    delete_query = """
    DELETE FROM APPOINTMENT
    WHERE Patient_Id = %s AND Date = %s AND Appointment_time = %s;
    """
    try:
        rows_deleted = execute_query(delete_query, (patient_id, appointment_date, appointment_time), fetchall=False)
        if rows_deleted:
            print("Failed to delete the appointment.")
        else:
            print(f"Deleted appointment for Patient ID {patient_id} on {appointment_date} at {appointment_time}.")       
    except Exception as e:
        print(f"Failed to delete appointment: {e}")



# Menu System with input validation
def menu():
    while True:
        print("\n--- Hospital Management System ---")
        print("1. Get doctors by department")
        print("2. Get patients treated by a doctor")
        print("3. Count doctors by department")
        print("4. Get appointments by date")
        print("5. Get available medicines")
        print("6. Update patient contact")
        print("7. Update Appointment Time")
        print("8. Restock medicine")
        print("9. Search patients by name")
        print("10. Surgeries report")
        print("11. Patient report")
        print("12. Insert new Doctor record")
        print("13. Delete Appointment")
        print("14. Exit")
        
        choice = input("Enter your choice (1-14): ")
        
        try:
            if choice == "1":
                department_id = int(input("Enter Department ID: "))
                get_doctors_by_department(department_id)
            elif choice == "2":
                doctor_id = int(input("Enter Doctor ID: "))
                get_patients_by_doctor(doctor_id)
            elif choice == "3":
                count_doctors_by_department()
            elif choice == "4":
                date = input("Enter date (YYYY-MM-DD): ")
                get_appointments_by_date(date)
            elif choice == "5":
                get_available_medicines()
            elif choice == "6":
                patient_id = int(input("Enter Patient ID: "))
                new_contact_no = input("Enter new contact number: ")
                update_patient_contact(patient_id, new_contact_no)
            elif choice == "7":
                patient_id = int(input("Enter Patient ID: "))
                new_app_time = input("Enter New Appointment Time (HH:MM:SS): ")
                update_app_time(patient_id, new_app_time)
            elif choice == "8":
                medicine_id = int(input("Enter Medicine ID: "))
                restock_amount = int(input("Enter restock amount: "))
                restock_medicine(medicine_id, restock_amount)
            elif choice == "9":
                name_substring = input("Enter name substring to search: ")
                search_patient_by_name(name_substring)
            elif choice == "10":
                surgeries_report()
            elif choice == "11":
                patient_report()
            elif choice == "12":
                doctor_data = (
                    input("Doctor Id:"),
                    input("First Name: "),
                    input("Middle Name (or leave blank): "),
                    input("Last Name: "),
                    input("Contact Number: "),
                    input("Gender: "),
                    input("Date of Birth (YYYY-MM-DD): "),
                    input("Deprtment ID: "),
                    input("Supervisor ID: ")
                )
                insert_new_doctor(doctor_data)
            elif choice == "13":
                 delete_appointment()
            elif choice == "14":
                print("Exiting... Goodbye!")
                break
            else:
                print("Invalid choice. Please enter a number between 1 and 9.")
        except ValueError as ve:
            print(f"Invalid input: {ve}. Please try again.")
        except Exception as e:
            print(f"An unexpected error occurred: {e}")

if __name__ == "__main__":
    menu()
