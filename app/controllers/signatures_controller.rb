class SignaturesController < ApplicationController

  def sign
    @sig = Signature.find(params[:id])
    @sig.sign!
    Shortlog.signature(@sig.brother, @sig.id, :sign)
    redirect_back root_path, success: 'You have successfully signed. '
  end

  def decline
    @sig = Signature.find(params[:id])
    @sig.decline!
    Shortlog.signature(@sig.brother, @sig.id, :decline)
    redirect_back root_path, success: 'You have successfully declined the signature. '
  end

end