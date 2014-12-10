
/////////////////////////////////////////////////////////////
// Validations
/////////////////////////////////////////////////////////////


$(document).ready(function() {
    

    $(".form-control").on('input', function() {
      $('#signup-form').data('bootstrapValidator').validate();
    });

    $('#signup-form')
        .bootstrapValidator({
        feedbackIcons: {
        },
        fields: {
          'user[address_line_1]': {
            message: 'The address field is not valid',
            validators: {
              notEmpty: {
                message: 'The address field can\'t be empty'
              },
              stringLength: {
                min: 3,
                message: '*The address must be a real'
              },
            }
          },
          'user[city]': {
            message: 'The city field is not valid',
            validators: {
              notEmpty: {
                message: '*The city is required'
              },  
              regexp: {
                regexp: /Boulder/g,
                message: 'TSYN is only available in Boulder'
              }
            }
          },
          'user[zip]': {
            message: 'The zip code field is not valid',
            validators: {
              notEmpty: {
                message: '*zip required'
              },
              between: {
                  min: 80301,
                  max: 80329,
                  message: 'Boulder zip required'
              }
            }
          },
          'user[state]': {
            message: 'The state field is not valid',
            validators: {
              notEmpty: {
                message: '* state required.'
              },
              stringLength: {
                min:2,
                message: "Valid state required"
              }
            }
          },
          // 'user[phone_number]': {
          //   message: 'The address field is not valid',
          //   validators: {
          //     notEmpty: {
          //       message: '*phone number required'
          //     },
          //     stringLength: {
          //       min: 10,
          //       message: 'Phone number invalid'
          //     },
          //   }
          // },
          'user[password]': {
            message: 'The password field is not valid',
            validators: {
              stringLength: {
              min: 8,
              message: 'The password must have at least 8 characters'
              }
             }
          },
          'user[password_confirmation]': {
            message: 'The password_confirmation field is not valid',
            validators: {
              identical: {
                field: 'user[password]',
                message: 'The password confirmation must match the password'
              }
             }
          }
        }
      });
  });




