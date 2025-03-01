
//
//  CravingMapper.swift
//  CravePhone
//
//  Uncle Bob & Steve Jobs Style:
//   - Now fully aligns DTO <-> Entity with 'emotions' field.
//   - Freed from optional checks by giving `emotions` a default in DTO init.
//

internal struct CravingMapper {
    
    func mapToEntity(_ dto: CravingDTO) -> CravingEntity {
        CravingEntity(
            id: dto.id,
            cravingDescription: dto.text,
            cravingStrength: dto.cravingStrength,
            confidenceToResist: dto.confidenceToResist,
            emotions: dto.emotions,
            timestamp: dto.timestamp,
            isArchived: dto.isArchived
        )
    }
    
    func mapToDTO(_ entity: CravingEntity) -> CravingDTO {
        CravingDTO(
            id: entity.id,
            text: entity.cravingDescription,
            confidenceToResist: entity.confidenceToResist,
            cravingStrength: entity.cravingStrength,
            timestamp: entity.timestamp,
            isArchived: entity.isArchived,
            emotions: entity.emotions
        )
    }
}






