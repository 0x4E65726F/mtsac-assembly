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

