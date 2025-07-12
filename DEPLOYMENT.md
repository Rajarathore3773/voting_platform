# Deployment Guide for Render

This guide will help you deploy the Voting Platform to Render.

## Prerequisites

1. A Render account (free tier available)
2. Your Rails application code in a Git repository (GitHub, GitLab, etc.)
3. Rails master key for production credentials

## Step 1: Prepare Your Application

### 1.1 Get Your Rails Master Key

Your Rails master key is required for production deployment. It's located in `config/master.key` (this file should NOT be committed to Git).

If you don't have it, you can generate a new one:

```bash
rails credentials:edit
```

### 1.2 Commit Your Changes

Make sure all your changes are committed to your Git repository:

```bash
git add .
git commit -m "Prepare for Render deployment"
git push origin main
```

## Step 2: Deploy to Render

### Option A: Using render.yaml (Recommended)

1. Go to [Render Dashboard](https://dashboard.render.com/)
2. Click "New +" and select "Blueprint"
3. Connect your Git repository
4. Render will automatically detect the `render.yaml` file and create the services

### Option B: Manual Setup

1. Go to [Render Dashboard](https://dashboard.render.com/)
2. Click "New +" and select "Web Service"
3. Connect your Git repository
4. Configure the service:
   - **Name**: `voting-platform`
   - **Environment**: `Ruby`
   - **Build Command**: `./bin/render-build.sh`
   - **Start Command**: `bundle exec puma -C config/puma.rb`

## Step 3: Configure Environment Variables

In your Render service settings, add these environment variables:

### Required Variables:
- `RAILS_MASTER_KEY`: Your Rails master key (from `config/master.key`)
- `RAILS_ENV`: `production`
- `RAILS_SERVE_STATIC_FILES`: `true`
- `RAILS_LOG_TO_STDOUT`: `true`

### Optional Variables:
- `RAILS_LOG_LEVEL`: `info` (or `debug` for more verbose logging)
- `WEB_CONCURRENCY`: `2` (number of Puma workers)
- `RAILS_MAX_THREADS`: `5` (database connection pool size)

## Step 4: Database Setup

### If using render.yaml:
The database will be created automatically.

### If setting up manually:
1. Create a new PostgreSQL database in Render
2. Copy the database URL to your web service's `DATABASE_URL` environment variable

## Step 5: Deploy

1. Click "Create Web Service"
2. Render will automatically:
   - Install dependencies
   - Precompile assets
   - Run database migrations
   - Start the application

## Step 6: Verify Deployment

1. Check the deployment logs for any errors
2. Visit your application URL
3. Test the voting functionality

## Troubleshooting

### Common Issues:

1. **Build Failures**:
   - Check that all gems are properly specified in Gemfile
   - Ensure `bin/render-build.sh` is executable
   - Verify Rails master key is set correctly

2. **Database Connection Issues**:
   - Ensure `DATABASE_URL` is set correctly
   - Check that database migrations can run

3. **Asset Compilation Issues**:
   - Verify `config.assets.compile = false` in production.rb
   - Check that all JavaScript dependencies are properly imported

4. **Runtime Errors**:
   - Check application logs in Render dashboard
   - Verify all environment variables are set

### Logs and Debugging:

- View logs in the Render dashboard
- Use `rails console` in Render's shell if needed
- Check the "Events" tab for deployment history

## Performance Optimization

### For Production:

1. **Caching**: The app uses Redis for caching if available
2. **Database**: Consider upgrading to a paid PostgreSQL plan for better performance
3. **Workers**: Adjust `WEB_CONCURRENCY` based on your traffic

### Monitoring:

- Use Render's built-in monitoring
- Consider adding Sentry for error tracking (already included in Gemfile)

## Security Considerations

1. **Environment Variables**: Never commit sensitive data to Git
2. **HTTPS**: Render provides SSL certificates automatically
3. **Database**: Use strong passwords and limit access
4. **Logs**: Be careful not to log sensitive information

## Scaling

When you need to scale:

1. **Upgrade Plan**: Move from free to paid plan
2. **Database**: Upgrade to dedicated PostgreSQL
3. **Redis**: Add Redis for better caching
4. **CDN**: Consider adding a CDN for static assets

## Support

- [Render Documentation](https://render.com/docs)
- [Rails Deployment Guide](https://guides.rubyonrails.org/deployment.html)
- [Puma Configuration](https://puma.io/puma/Puma/DSL.html) 