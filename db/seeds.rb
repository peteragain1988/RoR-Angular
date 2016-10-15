admin_company = Company.create(
    {
        name: 'EventHub',
        company_type: 'company',
        address1: '123 Fake Street',
        postcode: 2000,
        suburb: 'Suburbia',
        state: 'NSW',
        city: 'Sydney'
    }
)


admin_company.manager = Employee.create(
    {
        email: 'god@eventhub.com.au',
        password: '123456',
        can_login?: true,
        super_admin?: true,
        company_id: admin_company.id
    }
)

admin_company.manager.profile = Profile.create(
    {
        first_name: 'Omniscient',
        last_name: 'God',
        sex: 'Male',
        dob: '1970-01-01'
    }
)


admin_company.save!
admin_company.manager.save!
admin_company.manager.company = admin_company
admin_company.manager.save!