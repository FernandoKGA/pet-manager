require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { create(:user) }

  describe 'GET #new' do
    it "returns success response" do
      get :new
      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end

    it "render the template :new correctly" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let(:valid_info)    { { user: attributes_for(:user, email: 'teste@petmanager.com') } }
    let(:invalid_pass)  { { user: attributes_for(:user, password: 'teste123', password_confirmation: 'test') } }

    context 'valid data' do
      it "create a new user in database" do
        expect {
          post :create, params: valid_info
        }.to change(User, :count).by(1)
      end

      it "should return success" do
        post :create, params: valid_info
        expect(response).to redirect_to('/login')
      end
    end

    context 'passwords do not match' do
      it 'should not create the user and refresh the page' do
        expect {
          post :create, params: invalid_pass
        }.to_not change(User, :count) 
      
        expect(response).to have_http_status(:unprocessable_content)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    let(:other_user) { create(:user) } 
    
    let(:valid_attributes) { { first_name: 'NovoNome' } }
    let(:invalid_attributes) { { email: '' } } # Email não pode ser vazio

    context 'when user is logged in' do
      before do
        allow(controller).to receive(:current_user).and_return(user)
      end

      context 'updating their own profile with valid data' do
        before do
          patch :update, params: { id: user.id, user: valid_attributes }
        end

        it 'updates the user\'s attributes' do
          user.reload
          expect(user.first_name).to eq('NovoNome')
        end

        it 'redirects to the user show page' do
          expect(response).to redirect_to(user)
        end

        it 'sets a success flash message' do
          expect(flash[:notice]).to eq('Profile updated successfully')
        end
      end

      context 'updating with valid data but without changing password' do
        let(:attributes_with_blank_pass) { { first_name: 'UsuarioDois', password: '', password_confirmation: '' } }
        
        it 'updates the attributes' do
           patch :update, params: { id: user.id, user: attributes_with_blank_pass }
           user.reload
           expect(user.first_name).to eq('UsuarioDois')
        end

        it 'does not change the password' do
          old_digest = user.password_digest
          patch :update, params: { id: user.id, user: attributes_with_blank_pass }
          user.reload
          expect(user.password_digest).to eq(old_digest)
        end
      end

      context 'updating with invalid data' do
        before do
          patch :update, params: { id: user.id, user: invalid_attributes }
        end

        it 'does not update the user' do
          user.reload
          expect(user.email).to_not eq('')
        end

        it 're-renders the edit template' do
          expect(response).to render_template(:edit)
        end

        it 'returns an unprocessable_content status' do
          expect(response).to have_http_status(:unprocessable_content)
        end
      end

      context 'trying to update another user\'s profile' do
        it 'does not update the other user' do
          patch :update, params: { id: other_user.id, user: valid_attributes }
          other_user.reload
          expect(other_user.first_name).to_not eq('NovoNome')
        end
        
        it 'redirects to the login page' do
          patch :update, params: { id: other_user.id, user: valid_attributes }
          expect(response).to redirect_to('/login')
        end
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the login page' do
        patch :update, params: { id: user.id, user: valid_attributes }
        expect(response).to redirect_to('/login')
      end

      it 'does not update the user' do
        patch :update, params: { id: user.id, user: valid_attributes }
        user.reload
        expect(user.first_name).to_not eq('NovoNome')
      end
    end
  end

  describe 'GET #show' do
    context 'when user is logged in' do
      before do
        allow(controller).to receive(:current_user).and_return(user)
        get :show, params: { id: user.id }
      end

      it 'assigns @user correctly' do
        expect(assigns(:user)).to eq(user)
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login' do
        get :show, params: { id: user.id }
        expect(response).to redirect_to('/login')
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is the owner' do
      before do
        allow(controller).to receive(:current_user).and_return(user)
        get :edit, params: { id: user.id }
      end

      it 'returns success' do
        expect(response).to be_successful
      end

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end
    end

    context 'when user is NOT the owner' do
      let(:other_user) { create(:user) }
      it 'redirects to login' do
        allow(controller).to receive(:current_user).and_return(user)
        get :edit, params: { id: other_user.id }
        expect(response).to redirect_to('/login')
      end
    end
  end

  describe 'DELETE #remove_photo' do
    context 'authorized user' do
      before do
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'calls remove_photo! on the user' do
        expect_any_instance_of(User).to receive(:remove_photo!)
        delete :remove_photo, params: { id: user.id }
      end

      it 'redirects back to edit page' do
        delete :remove_photo, params: { id: user.id }
        expect(response).to redirect_to(edit_user_path(user))
      end

      it 'sets a flash message' do
        delete :remove_photo, params: { id: user.id }
        expect(flash[:notice]).to eq("Foto removida!")
      end
    end

    context 'unauthorized user' do
      let(:other_user) { create(:user) }
      it 'does not remove photo and redirects to login' do
        allow(controller).to receive(:current_user).and_return(user)
        delete :remove_photo, params: { id: other_user.id }
        expect(response).to redirect_to('/login')
      end
    end

    context 'user not logged in' do
      it 'redirects to login' do
        delete :remove_photo, params: { id: user.id }
        expect(response).to redirect_to('/login')
      end
    end
  end
end

