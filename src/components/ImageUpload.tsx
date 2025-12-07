import { useState, useRef } from 'react';
import { Upload, X, Image as ImageIcon } from 'lucide-react';

interface ImageUploadProps {
  onImageSelect: (file: File) => void;
  preview?: string | null;
  onRemove?: () => void;
  error?: string | null;
  required?: boolean;
}

export default function ImageUpload({
  onImageSelect,
  preview,
  onRemove,
  error,
  required = false
}: ImageUploadProps) {
  const [isDragging, setIsDragging] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleDragOver = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(true);
  };

  const handleDragLeave = () => {
    setIsDragging(false);
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);

    const file = e.dataTransfer.files[0];
    if (file && file.type.startsWith('image/')) {
      onImageSelect(file);
    }
  };

  const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      onImageSelect(file);
    }
  };

  return (
    <div>
      <label className="block text-sm font-medium text-gray-700 mb-2">
        Image du produit {required && <span className="text-red-500">*</span>}
      </label>

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-3 py-2 rounded-lg text-sm mb-2">
          {error}
        </div>
      )}

      {preview ? (
        <div className="relative">
          <img
            src={preview}
            alt="Aperçu"
            className="w-full h-48 object-cover rounded-lg border-2 border-gray-300"
          />
          {onRemove && (
            <button
              type="button"
              onClick={onRemove}
              className="absolute top-2 right-2 bg-red-500 text-white p-2 rounded-full hover:bg-red-600 transition-colors shadow-lg"
            >
              <X className="w-5 h-5" />
            </button>
          )}
        </div>
      ) : (
        <div
          onDragOver={handleDragOver}
          onDragLeave={handleDragLeave}
          onDrop={handleDrop}
          onClick={() => fileInputRef.current?.click()}
          className={`border-2 border-dashed rounded-lg p-8 text-center cursor-pointer transition-all ${
            isDragging
              ? 'border-blue-500 bg-blue-50'
              : 'border-gray-300 hover:border-blue-400 hover:bg-gray-50'
          }`}
        >
          <div className="flex flex-col items-center">
            {isDragging ? (
              <Upload className="w-12 h-12 text-blue-500 mb-3" />
            ) : (
              <ImageIcon className="w-12 h-12 text-gray-400 mb-3" />
            )}
            <p className="text-sm font-medium text-gray-700 mb-1">
              {isDragging ? 'Déposez l\'image ici' : 'Glissez-déposez une image'}
            </p>
            <p className="text-xs text-gray-500">
              ou cliquez pour sélectionner
            </p>
            <p className="text-xs text-gray-400 mt-2">
              PNG, JPG, WEBP (max 5 MB)
            </p>
          </div>
          <input
            ref={fileInputRef}
            type="file"
            accept="image/*"
            onChange={handleFileSelect}
            className="hidden"
          />
        </div>
      )}
    </div>
  );
}
