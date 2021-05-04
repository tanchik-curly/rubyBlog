require 'aws-sdk-s3'

class ArticlesController < ApplicationController

  def index
    # ------------------------------------
    # download from s3 bucket

    region = 'eu-north-1'
    s3_client = Aws::S3::Client.new(
      endpoint: 'https://rails-blog-articles.s3.eu-north-1.amazonaws.com', 
      region: region, 
      access_key_id: 'AKIAZH3A772PJ7GIM5MG', 
      secret_access_key: '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',
      force_path_style: true,
      ssl_verify_peer: false
    )
    s3 = Aws::S3::Resource.new(client: s3_client)

    file_path = "https://rails-blog-articles.s3.eu-north-1.amazonaws.com/Makeup-Beauty-Cover.jpg"
    @default_picture = s3.bucket('rails-blog-articles').object('Makeup-Beauty-Cover.jpg')
    # @default_picture = s3_client.get_object(bucket: 'rails-blog-articles', key: 'Makeup-Beauty-Cover.jpg')
    puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    puts @default_picture
    # ------------------------------------

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
    # store on s3 bucket

    if params[:article][:article_picture] != nil
      region = 'eu-north-1'
      s3_client = Aws::S3::Client.new(
        endpoint: 'https://rails-blog-articles.s3.eu-north-1.amazonaws.com', 
        region: region, 
        access_key_id: 'AKIAZH3A772PJ7GIM5MG', 
        secret_access_key: '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',
        force_path_style: true,
        ssl_verify_peer: false
      )
      s3 = Aws::S3::Resource.new(client: s3_client)
      puts s3
      obj = s3.bucket('rails-blog-articles').object('Makeup-Beauty-Cover.jpg')
      puts obj

      s3_client.put_object(
        key: params[:article][:article_picture].original_filename,
        body: params[:article][:article_picture],
        bucket: 'rails-blog-articles',
        content_type: params[:article][:article_picture].content_type
      )
    end

    # ----------------------------------------------

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

  def delete_image 
    @article = Article.find(params[:id])
    image = ActiveStorage::Attachment.find(params[:image_id])
    if @article == image.record
      image.purge
      redirect_back(fallback_location: request.referer)
    else
      redirect_to root_url, notice: 'Ahahah!'
    end
  end

  def my_articles
    @articles = Article.where(:author_email => current_user.email, :status => ['private', 'archived'])
      .paginate(:page => params[:page], :per_page => 4).order("created_at desc")
  end

  def search
    @articles = Article.where('title LIKE ?', "%" + params[:q] + "%")
  end

  def category_filter
    @articles = Article.where('category = ?', params[:category])
  end

  private
    def article_params
      params.require(:article).permit(:title, :body, :status, :article_picture, :author_nickname, :author_email, :category)
    end
end
