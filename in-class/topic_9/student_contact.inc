extern      exit
extern      get_nt_input
extern      atoi_nt

struc student_contact

    .name       resb        50
    .id         resb        20
    .address    resb        100
    .city       resb        50
    .state      resb        3
    .zip        resw        1

endstruc    

name_sz:        equ         (student_contact.id - student_contact.name)
id_sz:          equ         (student_contact.address - student_contact.id)
address_sz:     equ         (student_contact.city - student_contact.address)
city_sz:        equ         (student_contact.state - student_contact.city)
state_sz:       equ         (student_contact.zip - student_contact.state)
zip_sz:         equ         (student_contact_size - student_contact.zip)

