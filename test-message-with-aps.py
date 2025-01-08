import firebase_admin
from firebase_admin import credentials, messaging
from decouple import config

# Load the path to the service account key from the environment file
# service_account_path = config('SERVICE_ACCOUNT_PATH')

# Set the path manually (as per your example)
service_account_path = "/Users/sohag/Desktop/critical-alert-test-a8c92-firebase-adminsdk-re97v-4e421f4e4c.json"

# Initialize the Firebase app with the service account
cred = credentials.Certificate(service_account_path)
firebase_admin.initialize_app(cred)

def send_notification_to_all(message_title, message_body):
    # Create a message to send to all users
    message = messaging.Message(
        notification=messaging.Notification(
            title=message_title,
            body=message_body,
        ),
        topic='all',
        data={
            "title": message_title,
            "body": message_body,
            "critical": "true"
        },
        apns=messaging.APNSConfig(
            payload=messaging.APNSPayload(
                aps=messaging.Aps(
                    alert=messaging.ApsAlert(
                        title=message_title,
                        body=message_body
                    ),
                    badge=1,
                    sound=messaging.CriticalSound(
                        name="critical_alert.wav",
                        critical=1,
                        volume=1.0
                    )
                )
            )
        ),
    )

    # Send the notification
    try:
        response = messaging.send(message)
        print(f'[NOTIFICATION-SENT]: Successfully sent notification to all users:', response)
    except Exception as e:
        print('Failed to send notification:', e)

if __name__ == "__main__":
    # Notification details
    message_title = "Critical Alert"
    message_body = "This is a critical alert message for all users."

    # Sending notification to all users
    send_notification_to_all(message_title, message_body)
