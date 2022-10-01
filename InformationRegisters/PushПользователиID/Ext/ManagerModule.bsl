﻿Функция ПолучитьPushID(Пользователь) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	PushПользователиID.PushId КАК PushId
	|ИЗ
	|	РегистрСведений.PushПользователиID КАК PushПользователиID
	|ГДЕ
	|	PushПользователиID.Пользователь = &Пользователь";
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Возврат БюджетныйНаСервере.ДеСериализоватьОбъект(Выборка.PushId);		
	КонецЦикла;

КонецФункции

Процедура УстановитьPushID(Пользователь, ID) Экспорт
	НоваяЗапись = РегистрыСведений.PushПользователиID.СоздатьМенеджерЗаписи();
	НоваяЗапись.Пользователь = Пользователь;
	НоваяЗапись.PushId = БюджетныйНаСервере.СериализоватьОбъект(ID);
	НоваяЗапись.Записать();
	

КонецПроцедуры