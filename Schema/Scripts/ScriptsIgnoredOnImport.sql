
set identity_insert Tag on
GO

insert into Tag(TID, [Name], [Description])
    values
        (1, 'Login', 'User login session'),
        (2, 'Forget Password', 'User forget password session, use session to control that function only open in short time'),
        (3, 'Non-Verified New Account', 'Verify new account after register'),
        (4, 'Grant', 'Grant of APP to get resource owner''s AccessToken')
GO

set identity_insert Tag off
GO
