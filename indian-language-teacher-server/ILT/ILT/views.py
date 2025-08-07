from django.contrib.auth import authenticate
from django.views.decorators.csrf import csrf_exempt
from rest_framework.authtoken.models import Token
from api.models import User
from api.models import UserProgress
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.status import (
    HTTP_400_BAD_REQUEST,
    HTTP_404_NOT_FOUND,
    HTTP_200_OK,
    HTTP_201_CREATED    
)
from rest_framework.response import Response
import firebase_admin
from firebase_admin import auth

default_app = firebase_admin.initialize_app()


@csrf_exempt
@api_view(["POST"])
@permission_classes((AllowAny,))
def login(request):
    ph_number = request.data.get("ph_number")
    firebase_token = request.data.get("firebase_token")
    if ph_number is None or firebase_token is None:
        return Response({'error': 'Please provide both Phone Number and firebase_token'},
                        status=HTTP_400_BAD_REQUEST)
    
    try:
        decoded_token = auth.verify_id_token(firebase_token)
        uid = decoded_token['uid']
    except Exception as ex : 
        return Response({'error': str(ex)},
                        status=HTTP_400_BAD_REQUEST)
    
    #saving phone number to database
    try:
        user = User.objects.get(email=uid)
        user.mobile = ph_number
        user.save()
    except User.DoesNotExist:
        return Response({'error': 'User does not exist'},
                        status=HTTP_404_NOT_FOUND)
    
    #for authenticating user and firebase token
    user = authenticate(request=request, username=ph_number)

    if user is not None:
        # Generate token
        token, _ = Token.objects.get_or_create(user=user)
        
        # Create user progress
        language_codes = ['HI', 'MR', 'KN', 'TA', 'TE']
        for code in language_codes:
            for i in range(15):
                user_progress, _ = UserProgress.objects.get_or_create(
                    token=token,
                    language_code=code,
                    progress=0
                )
        
        # Return token to user
        return Response({'token': token.key}, status=HTTP_200_OK)
    

    # Save phone number to database
    user, created = User.objects.get_or_create(mobile=ph_number)
    if created:
        # set default values for new user
        user.is_active = True
        user.save()
        token, _ = Token.objects.get_or_create(user=user)
        #return Response({'token': token.key},
        #                status=HTTP_200_OK)
        # Create user progress
        language_codes = ['HI', 'MR', 'KN', 'TA', 'TE']
        for code in language_codes:
            for i in range(15):
                user_progress, _ = UserProgress.objects.get_or_create(
                    token=token,
                    language_code=code,
                    progress=0
                )
        return Response({'token': token.key}, status=HTTP_200_OK)
        
    else:
        return Response({'error': 'Invalid credentials'}, status=HTTP_400_BAD_REQUEST)


@csrf_exempt
@api_view(["GET"])
def sample_api(request):
    data = {'sample_data': 123}
    return Response(data, status=HTTP_200_OK)

@api_view(['POST'])
def add_user_progress(request):
    token = request.data.get('token')
    language_code = request.data.get('language_code')

    if not token:
        return Response({'error': 'Token is required'}, status=HTTP_400_BAD_REQUEST)
    if language_code not in ['HI', 'MR', 'KN', 'TA', 'TE']:
        return Response({'error': 'Invalid language code'}, status=HTTP_400_BAD_REQUEST)

    try:
        user = Token.objects.get(key=token).user
        user_progress = UserProgress.objects.get(mobile=user.mobile, language_code=language_code)
        user_progress.progress += 1
        user_progress.save()
    except Token.DoesNotExist:
        return Response({'error': 'Invalid token'}, status=HTTP_400_BAD_REQUEST)
    except UserProgress.DoesNotExist:
        user_progress = UserProgress.objects.create(token=token, language_code=language_code, progress=1)

    return Response({'message': 'User progress added successfully.'}, status=HTTP_201_CREATED)