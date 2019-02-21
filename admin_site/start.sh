#!/bin/bash

export LANG=en_GB.utf8
SCRIPT=scripts/post-install-dev.sh

CREATE_BIBOS_COMMAND=$(cat << EOF
from django.core.management.base import BaseCommand, CommandError
from django.contrib.auth import get_user_model

class Command(BaseCommand):
    help = 'Create a superuser with password'

    def add_arguments(self, parser):
        parser.add_argument(
            '--username', dest='username', default=None,
            help='Specifies the username for the superuser.',
        )
        parser.add_argument(
            '--email', dest='email', default=None,
            help='Specifies the email for the superuser.',
        )
        parser.add_argument(
            '--password', dest='password', default=None,
            help='Specifies the password for the superuser.',
        )

    def handle(self, *args, **options):
        password = options.get('password')
        username = options.get('username')
        email = options.get('email')

        if not password:
            raise CommandError("--password is required")
        if not username:
            raise CommandError("--password is required")
        if not email:
            raise CommandError("--password is required")

        User = get_user_model();
        super_user = User.objects.create_superuser(username, email, password)
EOF
)

ASSOCIATE_BIBOS_COMMAND=$(cat << EOF
from django.core.management.base import BaseCommand, CommandError
from django.contrib.auth import get_user_model
from account.models import UserProfile

class Command(BaseCommand):
    help = 'Make a user a super-admin'

    def add_arguments(self, parser):
        parser.add_argument(
            '--username', dest='username', default=None,
            help='Specifies the username for the superuser.',
        )

    def handle(self, *args, **options):
        username = options.get('username')

        if not username:
            raise CommandError("--password is required")

        User = get_user_model();
        user = User.objects.get(username=username)
        try:
            profile = user.bibos_profile
            profile.type = 0
            profile.save()
        except:
            profile = UserProfile.objects.create(user=user, type=0)
EOF
)

rm -f .database.db

mkdir -p system/management/commands/
touch system/management/__init__.py
touch system/management/commands/__init__.py
echo "${CREATE_BIBOS_COMMAND}" > system/management/commands/create_bibos_super.py
echo "${ASSOCIATE_BIBOS_COMMAND}" > system/management/commands/associate_bibos_super.py

sed '/"createsuperuser.*"/d' -i $SCRIPT
sed 's/"migrate --run-syncdb"/"migrate --run-syncdb"\n"associate_bibos_super --username $username"/g' -i $SCRIPT
sed 's/"migrate --run-syncdb"/"migrate --run-syncdb"\n"create_bibos_super --username $username --email $email --password thisisaverysecretpassword12"/g' -i $SCRIPT
echo "password" | ./$SCRIPT bibosadmin bibosadmin@magenta.dk localhost 8000
