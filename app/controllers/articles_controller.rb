require 'aws-sdk-s3'

class ArticlesController < ApplicationController

  def index
    @articles = Article.where("status = ?", "public").paginate(:page => params[:page], :per_page => 4).order("created_at desc")
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    # ------------------------------------
    region = 'eu-north-1'
    s3_client = Aws::S3::Client.new(region: region, access_key_id: 'AKIAZH3A772PJ7GIM5MG', secret_access_key: '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')
    puts 'ZZZZZZZZZZZZZZZZZZZZZZZZZZ!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    s3 = Aws::S3::Resource.new(client: s3_client)
    puts s3
    ha = s3.bucket('rails-blog-articles').object('Makeup-Beauty-Cover.jpg')
    puts ha
    # obj = s3_client.buckets['rails-blog-articles'].objects['Makeup-Beauty-Cover.jpg'] # no request made
    # Store an image on S3
    # s3_client.write("rails-blog-articles", open("/home/tanchik/blog/public/38iqur4116x41.jpg"))
    # s3_client.write(Pathname.new('/home/tanchik/blog/public/38iqur4116x41.jpg'))

    # See if it's on there
    # bucket = Bucket.find("38iqur4116x41.jpg")
    # p bucket["38iqur4116x41.jpg"]

    # helpers.list_buckets(s3_client)
    # -------------------------------

    @article = Article.new(article_params)
    @article.author_email = current_user.email

    if @article.save
      redirect_to @article
    else
      render :new
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to @article
    else
      render :edit
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path
  end

  def my_articles
    @articles = Article.where(:author_email => current_user.email, :status => ['private', 'archived'])
      .paginate(:page => params[:page], :per_page => 4).order("created_at desc")
  end

  def search
    @articles = Article.where('title = ?', params[:q])
  end

  private
    def article_params
      params.require(:article).permit(:title, :body, :status, :article_picture, :author_nickname, :author_email)
    end
end
