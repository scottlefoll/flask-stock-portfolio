INSERT INTO users (
        id, 
        email, 
        password_hashed, 
        registered_on, 
        email_confirmation_sent_on, 
        email_confirmed, 
        email_confirmed_on, 
        user_type
) VALUES (
        some_id, -- Replace with an appropriate integer value for the ID
        'scottlefoll@gmail.com',
        'some_password_hash', -- Replace with an appropriate hashed password
        '2023-08-06 11:28:15', -- Include both date and time
        '2023-08-06 11:28:15', -- Include both date and time
        1, -- Assuming email is confirmed, use 0 if not
        '2023-08-06 11:28:15', -- Include both date and time
        'Admin'
);
