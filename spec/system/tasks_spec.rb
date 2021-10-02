require 'rails_helper'

RSpec.describe 'ログイン機能', type: :system do

  let!(:user) { User.create(name: 'user_name', email: 'user@email.com', password: 'password') }

  describe '画面遷移要件' do
    describe '1.要件通りにパスのプレフィックスが使用できること' do
      context 'ログアウト中の場合' do
        it '要件通りにパスのプレフィックスが使用できること' do
          visit new_session_path
          visit new_user_path
        end
      end
      context 'ログイン中の場合' do
        before do
          visit root_path
          find('#sign-in').click
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          find('#create-session').click
        end
        it '要件通りにパスのプレフィックスが使用できること' do
          visit user_path(user)
          visit edit_user_path(user)
        end
      end
    end
  end

  describe '画面設計要件' do
    describe '2.要件通りにHTMLのid属性やclass属性が付与されていること' do
      context 'ログアウト中の場合' do
        it 'グローバルナビゲーション' do
          visit root_path
          expect(page).to have_css '#sign-up'
          expect(page).to have_css '#sign-in'
          expect(page).not_to have_css '#my-account'
          expect(page).not_to have_css '#sign-out'
          expect(page).not_to have_css '#tasks-index'
          expect(page).not_to have_css '#new-task'
        end
        it 'ログイン画面' do
          visit root_path
          find('#sign-in').click
          expect(page).to have_css '#create-session'
        end
        it 'アカウント登録画面' do
          visit root_path
          find('#sign-up').click
          expect(page).to have_css '#create-user'
        end
      end
      context 'ログイン中の場合' do
        before do
          visit root_path
          find('#sign-in').click
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          find('#create-session').click
        end
        it 'グローバルナビゲーション' do
          expect(page).to have_css '#my-account'
          expect(page).to have_css '#sign-out'
          expect(page).to have_css '#tasks-index'
          expect(page).to have_css '#new-task'
          expect(page).not_to have_css '#sign-up'
          expect(page).not_to have_css '#sign-in'
        end
        it 'アカウント詳細画面' do
          find('#my-account').click
          expect(page).to have_css '#edit-user'
        end
        it 'アカウント編集画面' do
          find('#my-account').click
          find('#edit-user').click
          expect(page).to have_css '#update-user'
          expect(page).to have_css '#戻る'
        end
      end
    end
  end

  describe '画面要件' do
    describe '3.要件通りに各画面に文字やリンク、ボタンを表示すること' do
      context 'ログアウト中の場合' do
        it 'グローバルナビゲーション' do
          visit root_path
          expect(page).to have_link 'アカウント登録'
          expect(page).to have_link 'ログイン'
        end
        it 'ログイン画面' do
          visit root_path
          click_link 'ログイン'
          expect(page).to have_content 'ログインページ'
          expect(page).to have_selector 'label', text: 'メールアドレス'
          expect(page).to have_selector 'label', text: 'パスワード'
          expect(page).to have_button 'ログイン'
        end
        it 'アカウント登録画面' do
          visit root_path
          click_link 'アカウント登録'
          expect(page).to have_content 'アカウント登録ページ'
          expect(page).to have_selector 'label', text: '名前'
          expect(page).to have_selector 'label', text: 'メールアドレス'
          expect(page).to have_selector 'label', text: 'パスワード'
          expect(page).to have_selector 'label', text: 'パスワード（確認）'
          expect(page).to have_button '登録する'
        end
      end
      context 'ログイン中の場合' do
        before do
          visit new_session_path
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          click_button 'ログイン'
        end
        it 'グローバルナビゲーション' do
          expect(page).to have_link 'タスク一覧'
          expect(page).to have_link 'タスクを登録する'
          expect(page).to have_link 'アカウント'
          expect(page).to have_link 'ログアウト'
        end
        it 'アカウント詳細画面' do
          click_link 'アカウント'
          expect(page).to have_content 'アカウント詳細ページ'
          expect(page).to have_content '名前'
          expect(page).to have_content 'メールアドレス'
          expect(page).to have_link '編集'
        end
        it 'アカウント編集画面' do
          click_link 'アカウント'
          click_link '編集'
          expect(page).to have_content 'アカウント編集ページ'
          expect(page).to have_selector 'label', text: '名前'
          expect(page).to have_selector 'label', text: 'メールアドレス'
          expect(page).to have_selector 'label', text: 'パスワード'
          expect(page).to have_selector 'label', text: 'パスワード（確認）'
          expect(page).to have_button '更新する'
          expect(page).to have_link '戻る'
        end
      end
    end
  end

  describe '画面遷移要件' do
    describe '画面遷移図通りに遷移させること' do
      context 'ログアウト中の場合' do
        it 'グローバルナビゲーションのリンクを要件通りに遷移させること' do
          visit root_path
          click_link 'ログイン'
          expect(page).to have_content 'ログインページ'
          click_link 'アカウント登録'
          expect(page).to have_content 'アカウント登録ページ'
        end
        it 'アカウント登録に成功した場合、ページタイトルに「タスク一覧ページ」が表示される' do
          visit new_user_path
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('new_password')
          find('input[name="user[password_confirmation]"]').set('new_password')
          click_button '登録する'
          expect(page).to have_content 'タスク一覧ページ'
        end
        it 'アカウント登録に失敗した場合、ページタイトルに「アカウント登録ページ」が表示される' do
          visit new_user_path
          find('input[name="user[name]"]').set('')
          find('input[name="user[email]"]').set('')
          find('input[name="user[password]"]').set('')
          find('input[name="user[password_confirmation]"]').set('')
          click_button '登録する'
          expect(page).to have_content 'アカウント登録ページ'
        end
        it 'ログインに成功した場合、ページタイトルに「タスク一覧ページ」が表示される' do
          visit new_session_path
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          click_button 'ログイン'
          expect(page).to have_content 'タスク一覧ページ'
        end
        it 'ログインに失敗した場合、ページタイトルに「ログインページ」が表示される' do
          visit new_session_path
          find('input[name="session[email]"]').set('failed@email.com')
          find('input[name="session[password]"]').set('failed_password')
          click_button 'ログイン'
          expect(page).to have_content 'ログインページ'
        end
      end
      context 'ログイン中の場合' do
        before do
          visit new_session_path
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          click_button 'ログイン'
        end
        it 'グローバルナビゲーションのリンクを要件通りに遷移させること' do
          click_link 'タスク一覧'
          expect(page).to have_content 'タスク一覧ページ'
          click_link 'タスクを登録する'
          expect(page).to have_content 'タスク登録ページ'
          click_link 'アカウント詳細'
          expect(page).to have_content 'アカウント詳細ページ'
          click_link 'ログアウト'
          expect(page).to have_content 'ログインページ'
        end
        it 'アカウント詳細画面の「編集」をクリックした場合、ページタイトルに「アカウント編集ページ」が表示される' do
          visit user_path(user)
          click_link '編集'
          expect(page).to have_content 'アカウント編集ページ'
        end
        it 'アカウントの編集に成功した場合、ページタイトルに「アカウント詳細ページ」が表示される' do
          visit edit_user_path(user)
          find('input[name="user[name]"]').set('edit_user_name')
          find('input[name="user[email]"]').set('edit_user@email.com')
          find('input[name="user[password]"]').set('edit_password')
          find('input[name="user[password_confirmation]"]').set('edit_password')
          click_button '更新する'
          expect(page).to have_content 'アカウント詳細ページ'
        end
        it 'アカウントの編集に失敗した場合、ページタイトルに「アカウント編集ページ」が表示される' do
          visit edit_user_path(user)
          find('input[name="user[name]"]').set('')
          find('input[name="user[email]"]').set('')
          find('input[name="user[password]"]').set('')
          find('input[name="user[password_confirmation]"]').set('')
          click_button '更新する'
          expect(page).to have_content 'アカウント編集ページ'
        end
        it 'アカウント編集画面の「戻る」をクリックした場合、ページタイトルに「アカウント詳細ページ」が表示される' do
          visit edit_user_path(user)
          click_link '戻る'
          expect(page).to have_content 'アカウント詳細ページ'
        end
      end
    end
  end

  describe '機能要件' do
    describe '10.アカウントの登録や編集に失敗した場合、要件で示した条件通りにバリデーションメッセージを表示させること' do
      context 'アカウント登録画面' do
        it 'すべてフォームが未入力の場合のバリデーションメッセージ' do
          visit new_user_path
          find('input[name="user[name]"]').set('')
          find('input[name="user[email]"]').set('')
          find('input[name="user[password]"]').set('')
          find('input[name="user[password_confirmation]"]').set('')
          click_button '登録する'
          expect(page).to have_content '名前を入力してください'
          expect(page).to have_content 'メールアドレスを入力してください'
          expect(page).to have_content 'パスワードを入力してください'
        end
        it 'すでに使用されているメールアドレスを入力した場合のバリデーションメッセージ' do
          visit new_user_path
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set(user.email)
          find('input[name="user[password]"]').set('password')
          find('input[name="user[password_confirmation]"]').set('password')
          click_button '登録する'
          expect(page).to have_content 'メールアドレスはすでに使用されています'
        end
        it 'パスワードが6文字未満の場合のバリデーションメッセージ' do
          visit new_user_path
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('passw')
          find('input[name="user[password_confirmation]"]').set('passw')
          click_button '登録する'
          expect(page).to have_content 'パスワードは6文字以上で入力してください'
        end
        it 'パスワードとパスワード（確認）が一致しない場合のバリデーションメッセージ' do
          visit new_user_path
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('password')
          find('input[name="user[password_confirmation]"]').set('passwordd')
          click_button '登録する'
          expect(page).to have_content 'パスワード（確認）とパスワードの入力が一致しません'
        end
      end
      context 'アカウント編集画面' do
        before do
          visit new_session_path
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          click_button 'ログイン'
        end
        it 'すべてフォームが未入力の場合のバリデーションメッセージ' do
          visit edit_user_path(user)
          find('input[name="user[name]"]').set('')
          find('input[name="user[email]"]').set('')
          find('input[name="user[password]"]').set('')
          find('input[name="user[password_confirmation]"]').set('')
          click_button '更新する'
          expect(page).to have_content '名前を入力してください'
          expect(page).to have_content 'メールアドレスを入力してください'
          expect(page).to have_content 'パスワードを入力してください'
        end
        it 'すでに使用されているメールアドレスを入力した場合のバリデーションメッセージ' do
          visit edit_user_path(user)
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set(admin.email)
          find('input[name="user[password]"]').set('password')
          find('input[name="user[password_confirmation]"]').set('password')
          click_button '更新する'
          expect(page).to have_content 'メールアドレスはすでに使用されています'
        end
        it 'パスワードが6文字未満の場合のバリデーションメッセージ' do
          visit edit_user_path(user)
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('passw')
          find('input[name="user[password_confirmation]"]').set('passw')
          click_button '更新する'
          expect(page).to have_content 'パスワードは6文字以上で入力してください'
        end
        it 'パスワードとパスワード（確認）が一致しない場合のバリデーションメッセージ' do
          visit edit_user_path(user)
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('password')
          find('input[name="user[password_confirmation]"]').set('passwordd')
          click_button '更新する'
          expect(page).to have_content 'パスワード（確認）とパスワードの入力が一致しません'
        end
      end
    end

    describe '11.要件で示した条件通りにフラッシュメッセージを表示させること' do
      context 'アカウントの登録に成功した場合' do
        it '「アカウントを登録しました」というフラッシュメッセージを表示させること' do
          visit new_user_path
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('new_password')
          find('input[name="user[password_confirmation]"]').set('new_password')
          click_button '登録する'
          expect(page).to have_content 'アカウントを登録しました'
        end
      end
      context 'アカウントの更新に成功した場合' do
        before do
          visit new_session_path
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          click_button 'ログイン'
        end
        it '「アカウントを更新しました」というフラッシュメッセージを表示させること' do
          visit edit_user_path(user)
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('new_password')
          find('input[name="user[password_confirmation]"]').set('new_password')
          click_button '更新する'
          expect(page).to have_content 'アカウントを更新しました'
        end
      end
      context 'ログインに成功した場合' do
        it '「ログインしました」というフラッシュメッセージを表示させること' do
          visit new_session_path
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          click_button 'ログイン'
          expect(page).to have_content 'ログインしました'
        end
      end
      context 'ログインに失敗した場合' do
        it '「メールアドレスまたはパスワードに誤りがあります」というフラッシュメッセージを表示させること' do
          visit new_session_path
          find('input[name="session[email]"]').set('failed_user@email.com')
          find('input[name="session[password]"]').set('failed_password')
          click_button 'ログイン'
          expect(page).to have_content 'メールアドレスまたはパスワードに誤りがあります'
        end
      end
      context 'ログアウトした場合' do
        before do
          visit new_session_path
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          click_button 'ログイン'
        end
        it '「ログアウトしました」というフラッシュメッセージを表示させること' do
          click_link 'ログアウト'
          expect(page).to have_content 'ログアウトしました'
        end
      end
    end

    describe '13.ユーザとタスクにアソシエーションを組み、タスク一覧画面に自分が作成したタスクのみ表示させること' do
      let!(:second_user) { User.create(name: 'second_user_name', email: 'second_user@email.com', password: 'password') }
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'ログイン'
      end
      it 'ユーザとタスクにアソシエーションを組み、タスク一覧画面に自分が作成したタスクのみ表示させること' do
        5.times do |n|
          Task.create(title: "task_title_#{n}", content: "task_content_#{n}", deadline_on: Date.today, priority: 0, status: 0, user_id: user.id)
          Task.create(title: "second_user_task_title_#{n}", content: "task_content_#{n}", deadline_on: Date.today, priority: 0, status: 0, user_id: second_user.id)
        end
        visit tasks_path
        5.times do |n|
          expect(page).to have_content "task_title_#{n}"
          expect(page).not_to have_content "second_user_task_title_#{n}"
        end
      end
    end

    describe '14.ログインをせずにログイン画面とアカウント登録画面以外にアクセスした場合、ログインページに遷移させ「ログインしてください」というフラッシュメッセージを表示させること' do
      let!(:task){Task.create(title: 'task_title', content: 'task_content', deadline_on: Date.today, priority: 0, status: 0, user_id: user.id)}
      it 'タスク一覧画面にアクセスした場合' do
        visit tasks_path
        expect(current_path).to eq new_session_path
        expect(page).to have_content 'ログインしてください'
      end
      it 'タスク登録画面にアクセスした場合' do
        visit new_task_path
        expect(current_path).to eq new_session_path
        expect(page).to have_content 'ログインしてください'
      end
      it 'タスク詳細画面にアクセスした場合' do
        visit task_path(task)
        expect(current_path).to eq new_session_path
        expect(page).to have_content 'ログインしてください'
      end
      it 'タスク編集画面にアクセスした場合' do
        visit edit_task_path(task)
        expect(current_path).to eq new_session_path
        expect(page).to have_content 'ログインしてください'
      end
      it 'アカウント詳細画面にアクセスした場合' do
        visit user_path(user)
        expect(current_path).to eq new_session_path
        expect(page).to have_content 'ログインしてください'
      end
      it 'アカウント編集画面にアクセスした場合' do
        visit edit_user_path(user)
        expect(current_path).to eq new_session_path
        expect(page).to have_content 'ログインしてください'
      end
    end

    describe '17.アカウントを削除した際、そのユーザに紐づいているすべてのタスクが削除されること' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'ログイン'
      end
      it 'ユーザを削除した際、そのユーザに紐づいているすべてのタスクが削除されること' do
        10.times do
          Task.create(title: 'task_title', content: 'task_content', deadline_on: Date.today, priority: 0, status: 0, user_id: user.id)
        end
        visit user_path(user)
        click_link 'アカウントを削除する'
        page.driver.browser.switch_to.alert.accept
        sleep 0.5
        expect(Task.all.count).to eq 0
      end
    end
  end
end

RSpec.describe 'デフォルトで実装されているタスク管理機能が正常に動作すること', type: :system do

  let!(:user) { User.create(name: 'user_name', email: 'user@email.com', password: 'password') }
  let!(:task) { Task.create(title: 'task_title', content: 'task_content', user_id: user.id) }

  before do
    visit root_path
    find('#sign-in').click
    find('input[name="session[email]"]').set(user.email)
    find('input[name="session[password]"]').set(user.password)
    find('#create-session').click
  end

  describe '' do
    describe '画面遷移' do
      it 'パスのプレフィックス' do
        visit tasks_path
        visit new_task_path
        visit task_path(task)
        visit edit_task_path(task)
      end
    end

    describe '画面に表示される要素' do
      it 'グローバルナビゲーション' do
        visit root_path
        expect(page).to have_link 'タスク一覧'
        expect(page).to have_link 'タスクを登録する'
      end
      it 'タスク一覧画面' do
        visit tasks_path
        expect(page).to have_content 'タスク一覧ページ'
        expect(page).to have_content task.title
        expect(page).to have_content task.content
        expect(page).to have_link '詳細'
        expect(page).to have_link '編集'
        expect(page).to have_link '削除'
      end
      it 'タスク登録画面' do
        visit new_task_path
        expect(page).to have_content 'タスク登録ページ'
        expect(page).to have_selector 'label', text: 'タイトル'
        expect(page).to have_selector 'label', text: '内容'
        expect(page).to have_button '登録する'
        expect(page).to have_link '戻る'
      end
      it 'タスク詳細画面' do
        visit task_path(task)
        expect(page).to have_content 'タスク詳細ページ'
        expect(page).to have_content task.title
        expect(page).to have_content task.content
        expect(page).to have_link '編集'
        expect(page).to have_link '戻る'
      end
      it 'タスク編集画面' do
        visit edit_task_path(task)
        expect(page).to have_content 'タスク編集ページ'
        expect(page).to have_selector 'label', text: 'タイトル'
        expect(page).to have_selector 'label', text: '内容'
        expect(page).to have_button '更新する'
        expect(page).to have_link '戻る'
      end
    end

    describe '画面遷移' do
      it 'グローバルナビゲーション' do
        visit tasks_path
        click_link 'タスクを登録する'
        expect(page).to have_content 'タスク登録ページ'
        click_link 'タスク一覧'
        expect(page).to have_content 'タスク一覧ページ'
      end
      it 'タスクを登録した場合、ページタイトルに「タスク一覧ページ」が表示される' do
        visit new_task_path
        fill_in 'タイトル', with: 'task_title'
        fill_in '内容', with: 'task_content'
        click_button '登録する'
        expect(page).to have_content 'タスク一覧ページ'
      end
      it '「詳細」をクリックした場合、ページタイトルに「タスク詳細ページ」が表示される' do
        visit tasks_path
        click_link '詳細'
        expect(page).to have_content 'タスク詳細ページ'
      end
      it '「編集」をクリックした場合、ページタイトルに「タスク編集ページ」が表示される' do
        visit tasks_path
        click_link '編集'
        expect(page).to have_content 'タスク編集ページ'
      end
      it '「更新する」をクリックした場合、ページタイトルに「タスク一覧ページ」が表示される' do
        visit edit_task_path(task)
        click_button '更新する'
        expect(page).to have_content 'タスク一覧ページ'
      end
      it '「削除」をクリックした場合、ページタイトルに「タスク一覧ページ」が表示される' do
        visit tasks_path
        click_link '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'タスク一覧ページ'
      end
      it '登録画面の「戻る」をクリックした場合、ページタイトルに「タスク一覧ページ」が表示される' do
        visit new_task_path
        click_link '戻る'
        expect(page).to have_content 'タスク一覧ページ'
      end
      it '詳細画面の「戻る」をクリックした場合、ページタイトルに「タスク一覧ページ」が表示される' do
        visit task_path(task)
        click_link '戻る'
        expect(page).to have_content 'タスク一覧ページ'
      end
      it '編集画面の「戻る」をクリックした場合、ページタイトルに「タスク一覧ページ」が表示される' do
        visit edit_task_path(task)
        click_link '戻る'
        expect(page).to have_content 'タスク一覧ページ'
      end
      it 'タスクの登録に失敗した場合、ページタイトルに「タスク登録ページ」が表示される' do
        visit new_task_path
        fill_in 'タイトル', with: ''
        fill_in '内容', with: ''
        click_button '登録する'
        expect(page).to have_content 'タスク登録ページ'
      end
      it 'タスクの編集に失敗した場合、ページタイトルに「タスク編集ページ」が表示される' do
        visit edit_task_path(task)
        fill_in 'タイトル', with: ''
        fill_in '内容', with: ''
        click_button '更新する'
        expect(page).to have_content 'タスク編集ページ'
      end
    end
  end

  describe '機能要件' do
    describe '確認ダイアログ' do
      it 'タスクを削除するリンクをクリックした際、確認ダイアログに「本当に削除してもよろしいですか？」という文字を表示させること' do
        visit tasks_path
        click_link '削除'
        expect(page.driver.browser.switch_to.alert.text).to eq '本当に削除してもよろしいですか？'
      end
    end
    describe 'バリデーションメッセージ' do
      context 'タスク登録画面' do
        it "タイトルが未入力の場合、「タイトルを入力してください」というバリデーションメッセージが表示させる" do
          visit new_task_path
          fill_in 'タイトル', with: ''
          fill_in '内容', with: ''
          click_button '登録する'
          expect(page).to have_content "タイトルを入力してください"
        end
        it "内容が未入力の場合、「内容を入力してください」というバリデーションメッセージが表示させる" do
          visit new_task_path
          fill_in 'タイトル', with: ''
          fill_in '内容', with: ''
          click_button '登録する'
          expect(page).to have_content "内容を入力してください"
        end
        it "タイトルと内容が未入力の場合、「タイトルを入力してください」と「内容を入力してください」というバリデーションメッセージが表示させる" do
          visit new_task_path
          fill_in 'タイトル', with: ''
          fill_in '内容', with: ''
          click_button '登録する'
          expect(page).to have_content "タイトルを入力してください"
          expect(page).to have_content "内容を入力してください"
        end
      end
      context 'タスク編集画面' do
        it "タイトルが未入力の場合、「タイトルを入力してください」というバリデーションメッセージが表示させる" do
          visit edit_task_path(task)
          fill_in 'タイトル', with: ''
          fill_in '内容', with: ''
          click_button '更新する'
          expect(page).to have_content "タイトルを入力してください"
        end
        it "内容が未入力の場合、「内容を入力してください」というバリデーションメッセージが表示させる" do
          visit edit_task_path(task)
          fill_in 'タイトル', with: ''
          fill_in '内容', with: ''
          click_button '更新する'
          expect(page).to have_content "内容を入力してください"
        end
        it "タイトルと内容が未入力の場合、「タイトルを入力してください」と「内容を入力してください」というバリデーションメッセージが表示させる" do
          visit edit_task_path(task)
          fill_in 'タイトル', with: ''
          fill_in '内容', with: ''
          click_button '更新する'
          expect(page).to have_content "タイトルを入力してください"
          expect(page).to have_content "内容を入力してください"
        end
      end
    end
    describe 'フラッシュメッセージ' do
      context 'タスクの登録に成功した場合' do
        it '「タスクを登録しました」というフラッシュメッセージを表示させること' do
          visit new_task_path
          fill_in 'タイトル', with: 'sample title'
          fill_in '内容', with: 'sample content'
          click_button '登録する'
          expect(page).to have_content "タスクを登録しました"
        end
      end
      context 'タスクの更新に成功した場合' do
        it '「タスクを更新しました」というフラッシュメッセージを表示させること' do
          visit edit_task_path(task)
          fill_in 'タイトル', with: 'update sample title'
          fill_in '内容', with: 'update sample content'
          click_button '更新する'
          expect(page).to have_content "タスクを更新しました"
        end
      end
      context 'タスクを削除した場合' do
        it '「タスクを削除しました」というフラッシュメッセージを表示させること' do
          visit tasks_path
          click_link '削除'
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content "タスクを削除しました"
        end
      end
    end
  end
end
