class UserPdf < Prawn: :Document
  def initialize(user)
    super()
    @user = user
    generate_pdf
  end

  def generate_pdf
    text "User information ", style: :bold, size:16
    move_down 20
    text "User Name : #{@user.name}"
    text "User Email : #{@user.email}"
    text "User Address : #{@user.address}"
    text "User City : #{@user.city}"

    save_as("user_info.pdf")
  end
end
