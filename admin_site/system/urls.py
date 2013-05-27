from django.conf.urls import patterns, url

from system import views


urlpatterns = patterns(
    '',
    url(r'^$', views.index, name='index'),
    url(r'^sites/', views.sites_overview, name='sites'),
    url(r'^site/(?P<site_uid>\w+)/$', views.site, name='site'),
    url(r'^site/(?P<site_uid>\w+)/configuration/', views.configuration,
        name='configuration'),
    url(r'^site/(?P<site_uid>\w+)/computers/', views.computers,
        name='computers'),
    url(r'^site/(?P<site_uid>\w+)/groups/', views.groups,
        name='groups'),
    url(r'^site/(?P<site_uid>\w+)/jobs/', views.jobs, name='jobs'),
    url(r'^site/(?P<site_uid>\w+)/scripts/', views.scripts, name='scripts'),
    url(r'^site/(?P<site_uid>\w+)/users/', views.users, name='users'),
)
